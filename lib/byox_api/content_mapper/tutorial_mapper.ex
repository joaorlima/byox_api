defmodule ByoxApi.ContentMapper.TutorialMapper do
  def map_and_create(tutorials_data) do
    data_split_by_languages =
      tutorials_data
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&data_split_by_languages/1)

    mapped_data =
      data_split_by_languages
      |> Enum.map(fn split_data ->
        {topic_title, tutorial_data} = split_data
        topic = ByoxApi.find_topic_by_title(topic_title)

        %{topic: topic, data: tutorial_data}
      end)

    mapped_data
    |> Enum.each(&create_tutorial_struct/1)
  end

  defp data_split_by_languages(data) do
    data
    |> split_languages()
  end

  defp split_languages({topic, items}) do
    new_items =
      items
      |> Enum.reject(&is_nil/1)
      |> Enum.flat_map(&split_languages_item(&1))

    {topic, new_items}
  end

  defp split_languages_item(%{title: title, url: url, language: language}) do
    if String.contains?(language, "/") do
      languages = String.split(language, "/")

      Enum.map(languages, fn lang ->
        %{title: title, url: url, language: lang}
      end)
    else
      [%{title: title, url: url, language: language}]
    end
  end

  defp create_tutorial_struct(mapped_data) do
    topic = Map.get(mapped_data, :topic)

    mapped_data
    |> Map.get(:data)
    |> Enum.map(fn tutorial_data ->
      {:ok, language} = tutorial_data.language |> String.trim() |> ByoxApi.get_language_by_name()

      %{
        title: tutorial_data.title,
        url: tutorial_data.url,
        topic_id: topic.id,
        language_id: language.id
      }
      |> ByoxApi.create_tutorial()
    end)
  end
end
