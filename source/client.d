import shard;
import api;
import vibe.d;
import std.stdio;
import types;
import container;

class Client
{
	private API api;
	User user;

	Cache!(User, Snowflake) users;
	Cache!(Guild, Snowflake) guilds;

	this()
	{
		this.api = new API(this);
		this.users = new Cache!(User, Snowflake)(this);
		this.guilds = new Cache!(Guild, Snowflake)(this);
	}

	void run(string token)
	{
		Shard shard = new Shard(this);
		string url = this.getGatewayURL() ~ "/?v=6&encoding=json";
		shard.connect(url, token);
	}

	string getGatewayURL()
	{
		Json gateway = this.api.getGateway();
		return gateway["url"].get!string;
	}
}
