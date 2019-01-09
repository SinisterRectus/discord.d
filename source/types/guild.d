import container;
import types;

// TODO: enums

class Guild : Container
{
	@JF("id") Snowflake id;
	@JF("owner_id") Snowflake ownerId;
	@JF("system_channel_id") Snowflake systemChannelId;
	@JF("application_id") Snowflake applicationId;
	@JF("afk_channel_id") Snowflake afkChannelId;

	@JF("name") string name;
	@JF("icon") string icon;
	@JF("splash") string splash;
	@JF("joined_at") string joinedAt;
	@JF("region") string region;

	@JF("lazy") bool lazy_;
	@JF("unavailable") bool unavailable;
	@JF("large") bool large;

	@JF("member_count") uint memberCount;
	@JF("afk_timeout") ushort afkTimeout;

	@JF("mfa_level") ubyte mfaSetting;
	@JF("verification_level") ubyte verificationLevel;
	@JF("explicit_content_filter") ubyte explicitContentSetting;
	@JF("default_message_notifications") ubyte notificationSetting;

	@JF("features") string[] features;

	Cache!(Role, Snowflake) roles;
	Cache!(Emoji, Snowflake) emojis;
	Cache!(Member, Snowflake) members;
	// Cache!(Channel, Snowflake) channels;
	// Cache!(VoiceState, Snowflake) voiceStates;

	mixin ContainerInit;

	static Snowflake hashJson(Json d)
	{
		return d["id"].to!Snowflake;
	}

	override void init(Json d)
	{
		this.roles = new Cache!(Role, Snowflake)(d["roles"], this.client);
		this.emojis = new Cache!(Emoji, Snowflake)(d["emojis"], this.client);
		this.members = new Cache!(Member, Snowflake)(d["members"], this.client);
		// this.channels = new Cache!Channel(d["channels"], this.client);
	}

}
