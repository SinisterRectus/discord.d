import std.format;
import std.system;

enum OPCode {
	DISPATCH = 0,
	HEARTBEAT = 1,
	IDENTIFY = 2,
	STATUS_UPDATE = 3,
	VOICE_STATE_UPDATE = 4,
	VOICE_SERVER_PING = 5,
	RESUME = 6,
	RECONNECT = 7,
	REQUEST_GUILD_MEMBERS = 8,
	INVALID_SESSION = 9,
	HELLO = 10,
	HEARTBEAT_ACK = 11,
	GUILD_SYNC = 12,
};

enum string[string] identifyProperties = [
	"$os": format("%s", os), // enum to string
	"$browser": "vibe.d",
	"$device": "vibe.d",
];

struct GatewayPayload(T) {
	OPCode op;
	T d;
}

struct IdentifyPayload {
	string token;
	string[string] properties;
	bool compress = false;
	ubyte large_threshold = 100;
	// uint[2] shard = [0, 1];
}

struct ResumePayload {
	string token;
	string session_id;
	uint seq;
}
