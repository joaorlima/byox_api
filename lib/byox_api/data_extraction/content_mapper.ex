defmodule ByoxApi.DataExtraction.ContentMapper do

  alias ByoxApi.DataExtraction.TutorialParser
  alias ByoxApi.DataExtraction.TopicParser

  alias ByoxApi.Content.Topics
  alias ByoxApi.Content.Tutorials

  def extract(data) do
    data
    |> Enum.map(&extract_data/1)
  end

  defp extract_data({topic_data, tutorials_data}) do
    topic =
      topic_data
      |> extract_topic_data()

    tutorials_data
    |> extract_tutorials_data(topic)
  end

  defp extract_topic_data(topic_data) do
    topic_data
    |> TopicParser.parse_topic_data()
    |> Topics.from_topic_data()
  end

  defp extract_tutorials_data(tutorials_data, topic) do
    tutorials_data
    |> TutorialParser.parse_tutorial()
    |> Enum.map(&Tutorials.from_tutorial_data(&1, topic))
  end

end
