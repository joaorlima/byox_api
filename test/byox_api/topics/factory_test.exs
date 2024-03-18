defmodule ByoxApi.Topics.FactoryTest do
  use ByoxApi.DataCase

  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic
  alias ByoxApi.Topics.Factory

  describe "create/1" do
    test "returns topic for valid input" do
      {:ok, topic} = Factory.create({:ok, "3D Renderer"})

      assert {:ok, title_from_db} = get_by_id(topic.id)
      assert title_from_db == topic
    end

    test "returns error tuple for invalid input" do
      {:error, :invalid_topic_data} = Factory.create({:error, :invalid_topic_data})
    end
  end

  defp get_by_id(id) do
    case Repo.get(Topic, id) do
      nil -> {:error, :not_found}
      topic -> {:ok, topic}
    end
  end

end
