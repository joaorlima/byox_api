defmodule ByoxApi.Service.TutorialMapper do
alias ByoxApi.Service.TopicMapper

  require Logger

  def extract(data) do
    data
    |> Enum.map(&extract_data/1)
  end

  defp extract_data({topic_data, list_of_tutorial_data}) do
    {:ok, topic_title} = TopicMapper.extract_topic_title_from_tag({topic_data, list_of_tutorial_data}) # TODO: change this later

    list_of_tutorial_data
    |> Enum.map(&extract_tutorial_data(&1, topic_title))
    |> Enum.map(&insert_tutorial/1)
  end

  defp extract_tutorial_data(tutorial_data, topic_title) do
    case Regex.run(
      ~r{<a href="(?<url>[^"]+)"><strong>(?<language>[^<]+)</strong>: <em>(?<title>[^<]+)</em></a>},
      tutorial_data,
      capture: [:url, :language, :title]
      ) do
      [url, language, title] ->
        {:ok, %{topic_title: topic_title, tutorial_data: [title: title, url: url, language: language]}}
      _ -> {:error, nil} # TODO: match remaining errors
    end
  end

  defp insert_tutorial({:ok, %{topic_title: topic_title, tutorial_data: [title: title, url: url, language: language]}}) do
    {:ok, language} = find_or_create_language(language) # TODO: extract to language mapper

    topic = ByoxApi.find_topic_by_title(topic_title)

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
