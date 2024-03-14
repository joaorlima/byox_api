defmodule ByoxApi.Service.TutorialMapper do

  require Logger

  def extract(_tutorials_data, :error), do: :error

  def extract(tutorials_data, {:ok, topic}) do
    tutorials_data
    |> Enum.map(&extract_tutorial_data(&1, topic.id))
    |> Enum.map(&insert_tutorial/1)
  end

  defp extract_tutorial_data(tutorial_data, topic_id) do
    case Regex.run(
      ~r{<a href="(?<url>[^"]+)"><strong>(?<language>[^<]+)</strong>: <em>(?<title>[^<]+)</em></a>},
      tutorial_data,
      capture: [:url, :language, :title]
      ) do
      [url, language, title] ->
        {:ok, %{topic_id: topic_id, tutorial_data: [title: title, url: url, language: language]}}
      _ ->
        log_error_message(tutorial_data)
        {:error, nil}
    end
  end

  defp insert_tutorial({:error, _}), do: :error

  defp insert_tutorial({:ok, %{topic_id: topic_id, tutorial_data: [title: title, url: url, language: language]}}) do
    {:ok, language} = find_or_create_language(language) # TODO: extract to language mapper

    %{
      title: title,
      url: url,
      topic_id: topic_id,
      language_id: language.id
    } |> ByoxApi.create_tutorial()
  end

  defp find_or_create_language(language_name) do
    case ByoxApi.get_language_by_name(language_name) do
      {:error, :not_found} -> %{name: language_name} |> ByoxApi.create_language()
      {:ok, language} -> {:ok, language}
    end
  end

  defp log_error_message(tutorial_data) do
    """
    Failed to extract tutorial contents from #{tutorial_data}.
    Check for missing tags or closing underscores.
    """
    |> Logger.error()
  end

end
