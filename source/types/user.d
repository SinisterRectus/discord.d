import container;

class User : Container
{
	@JF("id") Snowflake id;
	@JF("username") string username;
	@JF("discriminator") string discriminator;
	@JF("avatar") string avatar;
	@JF("email") string email;
	@JF("bot") bool bot;
	@JF("mfa_enabled") bool mfaEnabled;
	@JF("verified") bool verified;

	mixin ContainerInit;

	static Snowflake hashJson(Json d)
	{
		return d["id"].to!Snowflake;
	}
}
