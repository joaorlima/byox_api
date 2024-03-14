defmodule ByoxApi.Service.ContentMapper do

  alias ByoxApi.Service.TutorialMapper
  alias ByoxApi.Service.TopicMapper

  def extract(data) do
    data
    |> Enum.map(&extract_all_data/1)
  end

  defp extract_all_data({topic_data, tutorials_data}) do
    topic =
      topic_data
      |> TopicMapper.extract()

    tutorials_data
    |> TutorialMapper.extract(topic)
  end

end
