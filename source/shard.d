import vibe.d;

import std.format;
import std.system;
import std.stdio;
import std.functional;

import payloads;
import client;
import types;

class Shard
{
	private uint seq;
	private string sessionId;
	private WebSocket ws;
	private Timer heartbeater;
	private Client client;

	this(Client client)
	{
		this.client = client;
	}

	void connect(string url, string token)
	{
		return this.connect(URL(url), token);
	}

	void connect(URL url, string token)
	{
		this.ws = connectWebSocket(url);

		while (ws.waitForData()) {

			// TODO zlib
			Json payload = parseJsonString(ws.receiveText());

			OPCode op = payload["op"].get!OPCode;

			switch (op) with (OPCode)
			{
				case HELLO:
					logInfo("Received HELLO %s", payload["d"]["_trace"]);
					this.startHeartbeat(payload["d"]["heartbeat_interval"].get!uint);
					if (this.sessionId) {
						this.send(RESUME, ResumePayload(token, this.sessionId, this.seq));
					} else {
						this.send(IDENTIFY, IdentifyPayload(token, identifyProperties));
					}
					break;

				case INVALID_SESSION:
					if (this.sessionId && payload["d"].get!bool) {
						logInfo("Session invalidated, attemping to resume...");
						this.send(RESUME, ResumePayload(token, this.sessionId, this.seq));
					} else {
						logInfo("Session invalidated, attemping to re-identify...");
						this.send(IDENTIFY, IdentifyPayload(token, identifyProperties));
					}
					break;

				case DISPATCH:
					this.seq = payload["s"].get!uint;
					this.handleDispatch(payload["t"].get!string, payload["d"]);
					break;

				case HEARTBEAT:
					this.heartbeat();
					break;

				case HEARTBEAT_ACK:
					break;

				case RECONNECT:
					logInfo("Discord has requested a reconnection");
					this.ws.close();
					break;

				default:
					logInfo("Unhandled WebSocket payload: %s", op);
					break;
			}
		}

		logInfo("Gateway disconnected: %d %s", ws.closeCode, ws.closeReason);

		return this.connect(url, token); // TODO - fancy reconnecting
	}

	private void send(T) (OPCode op, T d)
	{
		string payload = serializeToJsonString(GatewayPayload!T(op, d));
		this.ws.send(payload);
	}

	private void startHeartbeat(uint interval)
	{
		if (this.heartbeater) {
			this.heartbeater.rearm(interval.msecs, true);
		} else {
			this.heartbeater = setTimer(interval.msecs, toDelegate(&this.heartbeat), true);
		}
	}

	private void stopHeartbeat()
	{
		this.heartbeater.stop();
	}

	private void heartbeat()
	{
		this.send(OPCode.HEARTBEAT, this.seq);
	}

	private void handleDispatch(string t, Json d)
	{
		switch (t)
		{
			case "READY":
				import std.stdio;
				logInfo("Received READY %s", d["_trace"]);
				this.sessionId = d["session_id"].get!string;
				this.client.user = this.client.users.load(d["user"]);
				break;

			case "GUILD_CREATE":
				this.client.guilds.load(d);
				break;

			case "RESUMED":
				logInfo("Received RESUMED %s", d["_trace"]);
				break;

			default:
				logInfo("Unhandled gateway event: %s", t);
				break;
		}
	}

}
