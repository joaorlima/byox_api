defmodule ByoxApi.Sync.Helper.ExtractLanguages do

  def map_and_create(tutorials_data) do
    tutorial_languages = tutorials_data
    |> Enum.map(&map_languages/1)

    tutorial_languages
    |> filter_unique_languages()
    |> Enum.each(&create_language/1)
  end

  defp map_languages(tutorials_data) do
    {_, topic_languages} = tutorials_data

    topic_languages
    |> Enum.reject(&is_nil/1)
    |> filter_topic_languages()
    |> Enum.map(&%{name: &1})
  end

  defp filter_topic_languages(topic_languages) do
    topic_languages
    |> Enum.flat_map(fn %{language: lang} ->
      String.split(lang, "/", trim: true)
      |> Enum.map(&String.trim/1)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp filter_unique_languages(tutorial_languages) do
    tutorial_languages
    |> Enum.flat_map(fn inner_list ->
        Enum.uniq_by(inner_list, fn %{name: name} -> name end)
      end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp create_language(languages) do
    case ByoxApi.create_language(languages) do
      {:error, _changeset} -> nil
      {:ok, language} -> %{name: language.name, id: language.id}
    end
  end

end
