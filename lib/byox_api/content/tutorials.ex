defmodule ByoxApi.Content.Tutorials do

  alias ByoxApi.Repo
  alias ByoxApi.Content.Tutorial
  alias ByoxApi.Content.Languages

  def create(params) do
    params
    |> Tutorial.changeset()
    |> Repo.insert()
  end

  def from_tutorial_data(_tutorial_data, {:error, :invalid_topic_data}), do: {:error, :invalid_topic}
  def from_tutorial_data({:error, :invalid_tutorial_data}, _topic_data), do: {:error, :invalid_tutorial}

  def from_tutorial_data({:ok, %{tutorial_data: [title: title, url: url, language: language]}}, {:ok, topic}) do
    {:ok, language} = Languages.find_or_create(language)

    %{
      title: title,
      url: url,
      topic_id: topic.id,
      language_id: language.id
    }
    |> create()
  end

end
