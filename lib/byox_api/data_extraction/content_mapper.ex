defmodule ByoxApi.DataExtraction.ContentMapper do

  alias ByoxApi.Tutorials.Mapper, as: TutorialMapper
  alias ByoxApi.Tutorials.Factory, as: TutorialFactory
  alias ByoxApi.Topics.Mapper, as: TopicMapper

  alias ByoxApi.Content.Topics

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
    |> TopicMapper.map()
    |> Topics.from_topic_data()
  end

  defp extract_tutorials_data(tutorials_data, topic) do
    tutorials_data
    |> TutorialMapper.map()
    |> Enum.map(&TutorialFactory.create(&1, topic))
  end

end
