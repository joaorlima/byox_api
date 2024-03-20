defmodule ByoxApi.Tutorials.Factory do

  alias ByoxApi.Content.Languages

  def create(_tutorial_data, {:error, :invalid_topic_data}), do: {:error, :invalid_topic}
  def create({:error, :invalid_tutorial_data}, _topic_data), do: {:error, :invalid_tutorial}

  def create({:ok, %{tutorial_data: [title: title, url: url, language: language]}}, {:ok, topic}) do
    {:ok, language} = Languages.find_or_create(language)

    %{
      title: title,
      url: url,
      topic_id: topic.id,
      language_id: language.id
    } |> ByoxApi.create_tutorial()
  end

end
