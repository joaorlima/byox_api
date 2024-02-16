# Build your own X API

The [Build Your Own X](https://github.com/codecrafters-io/build-your-own-x) is a GitHub repository with a collection of guides for building various technologies from scratch, like web servers, command-line tools, and search engines. No longer a passenger in the digital express, Build Your Own X equips you with the engine and blueprint to design your own technological journey.

The BYOX API is a GraphQL interface for the contents of the Build Your Own X repository. It parses and syncs the [contents](https://github.com/codecrafters-io/build-your-own-x/blob/master/README.md) of the repository into `Topic`, `Language` and `Tutorial` structures and it allows you to query by these structures.

You can query a topic with an exact search and a keyword search:

```graphql
query {
  topic(title: "3D Renderer") {
    title
  }
}
```

```graphql
query {
  topic(title: "3d") {
    title
  }
}
```

And both would give you the same output.

![image](https://github.com/joaorlima/byox_api/assets/38928059/58753738-f7c3-4325-aad7-5f7921f00b80)

You can also search for tutorials within a given topic, for example:

```graphql
query {
  topic(title: "Voxel") {
    title
    tutorials {
      title
      url
      languageId
    }
  }
}
```

would give you

![image](https://github.com/joaorlima/byox_api/assets/38928059/fa9894e4-b894-41b5-98d8-70ea7b92955e)

You can also search for tutorials for a given language, for example

```graphql
query {
 language(name: "PHP") {
    tutorials {
      title
      url
    }
  }
}
```

![image](https://github.com/joaorlima/byox_api/assets/38928059/c0da8a9e-2d6b-4381-8a09-310a625f6a91)


## Sync and start Phoenix server

### Sync
* To sync the contents of the repository, run `mix setup` to install and setup the dependencies
* Run `ByoxApi.Sync.sync` inside IEx with `iex -S mix`

### Server
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000/api/graphiql) from your browser to interact with GraphQL.
