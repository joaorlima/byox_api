defmodule ByoxApi.Topics.FactoryTest do
  use ByoxApi.DataCase

  alias ByoxApi.Topics.Factory

  describe "create/1" do
    test "returns topic for valid input" do
      {:ok, topic} = Factory.create({:ok, "3D Renderer"})

      assert topic.title == "3D Renderer"
    end

    test "returns error tuple for invalid input" do
      {:error, :invalid_topic_data} = Factory.create({:error, :invalid_topic_data})
    end
  end

end
