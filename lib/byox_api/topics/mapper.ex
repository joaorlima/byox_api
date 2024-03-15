defmodule ByoxApi.Topics.Mapper do

  require Logger

  def map(topic_data) do
    topic_data
    |> extract_topic_info_from_tag()
  end

  defp extract_topic_info_from_tag(topic_data) do
    case Regex.run(
      ~r{<a href="#[^>]+">(?<topic>[^<]+)</a>}, topic_data,
      capture: [:topic]
      ) do
      [topic_title] ->
        {:ok, topic_title}
      _ ->
        log_error_message(topic_data)
        {:error, :invalid_topic_data}
    end
  end

  defp log_error_message(topic_tag) do
    """
    Failed to extract topic from #{topic_tag}.
    Possible cause: missing or unmatched brackets or tags in the topic tag.
    """
    |> Logger.error()
  end

end
