defmodule ByoxApi.Service.ContentMapper do

  alias ByoxApi.Tutorials.Mapper, as: TutorialMapper
  alias ByoxApi.Tutorials.Factory, as: TutorialFactory
  alias ByoxApi.Topics.Mapper, as: TopicMapper
  alias ByoxApi.Topics.Factory, as: TopicFactory

  def extract(data) do
    data
    |> Enum.map(&extract_all_data/1)
  end

  defp extract_all_data({topic_data, tutorials_data}) do
    topic =
      TopicMapper.map(topic_data)
      |> TopicFactory.create()

    tutorials_data
    |> TutorialMapper.map()
    |> Enum.map(&TutorialFactory.create(&1, topic))
  end

end
