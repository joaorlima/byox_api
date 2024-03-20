defmodule ByoxApi.Content.Topics do

  alias ByoxApi.Repo
  alias ByoxApi.Content.Topic
  alias ByoxApi.Content.Language

  import Ecto.Query

  def create(params) do
    params
    |> Topic.changeset()
    |> Repo.insert()
  end

  @spec get_by_title(title :: String.t()) :: nil | {:ok, Language.t()}
  def get_by_title(title) do
    case Repo.get_by(Topic, title: title) do
      nil -> nil
      topic -> topic |> Repo.preload(:tutorials)
    end
  end

  @spec find_similar_by_title(title :: String.t()) :: {:error, :not_found} | {:ok, [Topic.t()]}
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

  @spec from_topic_data(params :: {:error, :invalid_topic_data} | {:ok, String.t()}) :: {:error, Ecto.Changeset.t()} | {:ok, Topic.t()}
  def from_topic_data({:error, _}), do: {:error, :invalid_topic_data}
  def from_topic_data({:ok, topic_title}) do
    %{
      title: topic_title
    } |> create()
  end

end
