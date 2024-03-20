defmodule ByoxApi.Factories.SchemaFactory do
  use ExMachina.Ecto, repo: ByoxApi.Repo

  alias ByoxApi.Repo
  alias ByoxApi.Content.Language
  alias ByoxApi.Content.Topic
  alias ByoxApi.Content.Tutorial

  def language_factory do
    %Language{
      name: "Elixir"
    }
  end

  def topic_factory do
    %Topic{
      title: "Web Server"
    }
  end

  def tutorial_factory do
    language = Repo.get_by(Language, name: "Elixir")
    topic = Repo.get_by(Topic, title: "Web Server")

    %Tutorial{
      title: "Web Server",
      url: "https://www.mocked.com/web-server",
      topic_id: topic.id,
      language_id: language.id,
    }
  end

end
