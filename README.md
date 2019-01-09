# discord.d

Discord API library written in D. Mostly written as a learning exercise / proof of concept. Not intended for release. Code may not be idiomatic D.

This is **very incomplete** and may never be finished. Only a very basic gateway connection is implemented.

Note that this is packaged here as an application, not as a library, so `app.d` exists within the `source` directory.

### Installation

- Install [DMD](https://dlang.org/) (tested on 2.084.0)
- Clone the repository
- Run `dub` in the main directory

### Example

```d
import client;

enum string token = "Bot TOKEN";

void main()
{
	Client client = new Client();
	client.run(token);
}
```
