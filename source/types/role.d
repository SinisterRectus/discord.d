import container;

class Role : Container
{
	@JF("id") Snowflake id;
	@JF("name") string name;

	@JF("managed") bool managed;
	@JF("hoist") bool hoist;

	@JF("permissions") uint permissions;
	@JF("color") uint color;
	@JF("position") short position;

	mixin ContainerInit;

	static Snowflake hashJson(Json d)
	{
		return d["id"].to!Snowflake;
	}
}
