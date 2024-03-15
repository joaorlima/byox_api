defmodule ByoxApi.Tutorials.Factory do

  def create(_tutorial_data, {:error, :rename_this}), do: {:error, :invalid_topic}
  def create({:error, :invalid_tutorial_data}, _topic_data), do: {:error, :invalid_tutorial}

  def create({:ok, %{tutorial_data: [title: title, url: url, language: language]}}, {:ok, topic}) do
    {:ok, language} = find_or_create_language(language)

    %{
      title: title,
      url: url,
      topic_id: topic.id,
      language_id: language.id
    } |> ByoxApi.create_tutorial()
  end

  defp find_or_create_language(language_name) do
    case ByoxApi.get_language_by_name(language_name) do
      {:error, :not_found} -> %{name: language_name} |> ByoxApi.create_language()
      {:ok, language} -> {:ok, language}
    end
  end

end
