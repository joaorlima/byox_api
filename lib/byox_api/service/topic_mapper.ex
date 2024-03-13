defmodule ByoxApi.Service.TopicMapper do

  require Logger

  def extract(data) do
    data
    |> Enum.map(&extract_topic_title_from_tag/1)
    |> Enum.each(&insert_topic/1)
  end

  # rename tag to data
  def extract_topic_title_from_tag({topic_data, _tutorial_data}) do
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

  defp insert_topic({:ok, topic_title}) do
    %{
      title: topic_title
    }
    |> ByoxApi.create_topic()
  end

  defp insert_topic({:error, _}), do: :error

  defp log_error_message(topic_tag) do
    """
    Failed to extract topic from #{topic_tag}.
    Possible cause: missing or unmatched brackets or tags in the topic tag.
    """
    |> Logger.error()
  end

end
