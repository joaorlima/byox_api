defmodule ByoxApi.Topics.Get do
  alias ByoxApi.Repo
  alias ByoxApi.Content.Topic

  import Ecto.Query

  def find_similar_by_title(title) do
    topics = Repo.all(from(t in Topic, where: ilike(t.title, ^"%#{title}%")))

    case topics do
      [] ->
        {:error, :not_found}

      topics ->
        topics =
          topics
          |> Enum.map(&Repo.preload(&1, tutorials: [:language]))

        {:ok, topics}
    end
  end

  def find_by_title(title) do
    case Repo.get_by(Topic, title: title) do
      nil -> nil
      topic -> topic |> Repo.preload(:tutorials)
    end
  end

end
