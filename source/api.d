import vibe.d;
import client;
import endpoints;
import std.format;

class API
{
	private Client client;
	private string token;
	private string userAgent = "DiscordBot";
	private string base = "https://discordapp.com/api/v7";

	this(Client client)
	{
		this.client = client;
	}

	void authenticate(string token)
	{
		this.token = token;
	}

	private Json request(T)(HTTPMethod method, string endpoint, string[string] query = null, T payload = null)
	{

		URL url = URL(this.base ~ endpoint);

		if (query)
		{
			string[] buf;
			foreach (ref k, ref v; query)
				buf ~= format("%s=%s", k, urlEncode(v));
			url.queryString = buf.join("&");
		}

		// TODO ratelimiting
		HTTPClientResponse res = requestHTTP(url, (scope req) {
			req.method = method;
			req.headers["Authorization"] = this.token;
			req.headers["User-Agent"] = this.userAgent;
			if (payload) // TODO might need to write an empty payload on certain reqs
				req.writeJsonBody(payload);
			logInfo(req.toString);
		});
		logInfo(res.toString);

		try
		{
			Json json = res.readJson();
			// logInfo(json.toPrettyString);
			return json;
		}
		catch
		{
			logInfo(res.bodyReader.readAllUTF8);
			return Json();
		}

	}

	Json getCurrentUser()
	{
		return this.request(HTTPMethod.GET, Endpoints.USERS_ME);
	}

	Json getGateway()
	{
		return this.request(HTTPMethod.GET, Endpoints.GATEWAY);
	}

	Json createMessage(T)(string channelId, T payload)
	{
		string endpoint = Endpoints.CHANNEL_MESSAGES.format(channelId);
		return this.request(HTTPMethod.POST, endpoint, null, payload);
	}

	Json getChannelMessages(string channelId, string[string] query)
	{
		string endpoint = Endpoints.CHANNEL_MESSAGES.format(channelId);
		return this.request(HTTPMethod.GET, endpoint, query);
	}
}
