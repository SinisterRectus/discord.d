import std.traits;
import vibe.d : Json;
import std.stdio : writeln;

alias Snowflake = string;

struct JsonField
{
	string name;
}

alias JF = JsonField;

void loadField(T)(ref T member, Json source)
{
	if (source.type == Json.Type.undefined) {
		return;
	}	else if (source.type == Json.Type.null_) {
		member = T.init;
	} else {
		member = source.get!T;
	}
}

void loadJson(T)(T obj, Json d)
{
	foreach(string memberName; __traits(allMembers, T))
	{
		static if (hasUDA!(__traits(getMember, T, memberName), JsonField))
		{
			alias MemberType = typeof(__traits(getMember, T, memberName));
			string key = getUDAs!(__traits(getMember, T, memberName), JsonField)[0].name;
			static if (isArray!MemberType && !isSomeString!MemberType) {
				alias ElementType = typeof(__traits(getMember, T, memberName)[0]);
				foreach (v; d[key])
					__traits(getMember, obj, memberName) ~= v.get!ElementType;
			} else {
				loadField(__traits(getMember, obj, memberName), d[key]);
			}
		}
	}
}

void dumpObject(T)(T obj)
{
	import std.stdio : writeln;
	foreach(string memberName; __traits(allMembers, T))
	{
		static if (hasUDA!(__traits(getMember, T, memberName), JsonField))
		{
			alias MemberType = typeof(__traits(getMember, T, memberName));
			writeln(MemberType.stringof, " " , memberName, " : ", __traits(getMember, obj, memberName));
		}
	}
}

class Container
{
	void init(Json d)
	{
	}
}

mixin template ContainerInit()
{
	import client : Client;
	import vibe.d : Json;

	Client client;

	this(Json d, Client client)
	{
		this.client = client;
		loadJson(this, d);
		this.init(d);
	}

	void dump()
	{
		dumpObject(this);
	}

}
