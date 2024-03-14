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

```json
{
    "data": {
        "topic": [
            {
                "title": "3D Renderer"
            }
        ]
    }
}
```

You can also search for tutorials within a given topic, for example:

```graphql
query {
  topic(title: "Voxel") {
    title
    tutorials {
      title
      url
      language {
        name
      }
    }
  }
}
```

would give you

```json
{
    "data": {
        "topic": [
            {
                "title": "Voxel Engine",
                "tutorials": [
                    {
                        "language": {
                            "name": "C++"
                        },
                        "title": "Let’s Make a Voxel Engine",
                        "url": "https://sites.google.com/site/letsmakeavoxelengine/home"
                    },
                    {
                        "language": {
                            "name": "Java"
                        },
                        "title": "Java Voxel Engine Tutorial",
                        "url": "https://www.youtube.com/watch?v=QZ4Vk2PkPZk&amp;list=PL80Zqpd23vJfyWQi-8FKDbeO_ZQamLKJL"
                    }
                ]
            }
        ]
    }
}
```

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

```json
{
    "data": {
        "language": {
            "tutorials": [
                {
                    "title": "Writing a webserver in pure PHP",
                    "url": "http://station.clancats.com/writing-a-webserver-in-pure-php/"
                },
                {
                    "title": "Write your own MVC from scratch in PHP",
                    "url": "https://chaitya62.github.io/2018/04/29/Writing-your-own-MVC-from-Scratch-in-PHP.html"
                },
                {
                    "title": "Make your own blog",
                    "url": "https://ilovephp.jondh.me.uk/en/tutorial/make-your-own-blog"
                },
                {
                    "title": "Modern PHP Without a Framework",
                    "url": "https://kevinsmith.io/modern-php-without-a-framework"
                },
                {
                    "title": "Code a Web Search Engine in PHP",
                    "url": "https://boyter.org/2013/01/code-for-a-search-engine-in-php-part-1/"
                }
            ]
        }
    }
}
```


## Sync and start Phoenix server

### Sync
* To sync the contents of the repository, run `mix setup` to install and setup the dependencies
* Seed the database by running `mix run priv/repo/seeds.exs`

### Server
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000/api/graphiql) from your browser to interact with GraphQL.
