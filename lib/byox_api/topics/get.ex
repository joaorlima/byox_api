defmodule ByoxApi.Topics.Get do
  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic

  import Ecto.Query

  def get_by_title(title) do
    topics = Repo.all(from(t in Topic, where: ilike(t.title, ^"%#{title}%")))

    case topics do
      [] ->
        {:error, :not_found}

      topics ->
        topics =
          topics
          |> Enum.map(&create_topic_struct/1)
          |> Repo.preload(tutorials: [:language])

        {:ok, topics}
    end
  end

  def find_by_title(title) do
    case Repo.get_by(Topic, title: title) do
      nil -> nil
      topic -> topic |> create_topic_struct()
    end
  end

  defp create_topic_struct(topic) do
    %Topic{id: topic.id, title: topic.title}
  end
end
