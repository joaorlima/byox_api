defmodule ByoxApi.Service.DataMapper do

  alias ByoxApi.Service.TutorialMapper
  alias ByoxApi.Service.TopicMapper

  def extract(data) do
    data
    |> Enum.map(&extract_all_data/1)
  end

  defp extract_all_data({topic_data, tutorials_data}) do
    # topic =
    #   topic_data
    #   |> TopicMapper.extract()

    topic =
      topic_data
      |> TopicMapper.extract()
      # |> TopicMapper.extract_topic_title_from_tag_2()
      # |> TopicMapper.insert_topic()

    tutorials_data
    |> TutorialMapper.extract(topic)
  end

end
