import vibe.d : Json;
import client : Client;

class Cache(T, K)
{
	T[K] data;
	Client client;

	this(Client client)
	{
		this.client = client;
	}

	this(Json arr, Client client)
	{
		this(client);
		foreach(ref d; arr)
		{
			this.data[T.hashJson(d)] = new T(d, client);
		}
	}

	T load(Json d)
	{
		K key = T.hashJson(d);
		if (key in this.data) {
			return this.data[key]; // TODO: object updating
		} else {
			return this.data[key] = new T(d, this.client);
		}
	}

}
