import container;
import user;

class Member : Container
{
	@JF("deaf") bool deafened;
	@JF("mute") bool muted;
	@JF("joined_at") string joinedAt;
	@JF("nick") string nickname;
	@JF("roles") Snowflake[] roles;

	User user;

	mixin ContainerInit;

	static Snowflake hashJson(Json d)
	{
		return d["user"]["id"].to!Snowflake;
	}

	override void init(Json d)
	{
		this.user = this.client.users.load(d["user"]);
	}
}
