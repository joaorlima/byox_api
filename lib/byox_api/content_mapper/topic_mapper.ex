defmodule ByoxApi.ContentMapper.TopicMapper do
  def map_and_create(tutorials_data) do
    tutorials_data
    |> map()
    |> create_topic()
  end

  defp map(tutorials_data) do
    {topic_title, _} = tutorials_data
    %{title: topic_title}
  end

  defp create_topic(topic_data) do
    ByoxApi.create_topic(topic_data)
  end
end
