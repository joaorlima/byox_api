defmodule ByoxApi.Topics.Get do

  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic

  import Ecto.Query

  def call(title) do
    topics = Repo.all(
      from(t in Topic, where: ilike(t.title, ^"%#{title}%"))
    )

    case topics do
      [] -> {:error, :not_found}
      topics ->
        topics = topics
         |> create_topics_struct()
         |> Repo.preload(:tutorials)

      {:ok, topics}
    end
  end

  defp create_topics_struct(topics) do
    topics
    |> Enum.map(fn topic -> %Topic{id: topic.id, title: topic.title} end)
  end

end
