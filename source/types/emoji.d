import container;

class Emoji : Container
{
	@JF("id") Snowflake id;
	@JF("animated") bool animated;
	@JF("managed") bool managed;
	@JF("require_colors") bool requireColons;
	@JF("roles") Snowflake[] roles;

	mixin ContainerInit;

	static Snowflake hashJson(Json d)
	{
		return d["id"].to!Snowflake;
	}

}
