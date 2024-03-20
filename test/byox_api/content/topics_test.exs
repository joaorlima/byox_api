defmodule ByoxApi.Content.TopicsTest do
  use ByoxApi.DataCase

  alias ByoxApi.Content.Topic
  alias ByoxApi.Content.Topics
  alias ByoxApi.Factories.SchemaFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "create/1" do
    test "fails to create a topic with invalid params" do
      params = %{title: ""}

      assert {:error, %Ecto.Changeset{valid?: false}} = Topics.create(params)
    end

    test "creates a new topic with valid params" do
      params = Factory.string_params_for(:topic)

      assert {:ok, %Topic{} = created_topic} = Topics.create(params)

      topic_from_db = Repo.get(Topic, created_topic.id)
      assert created_topic == topic_from_db
    end
  end

  describe "get_by_title/1" do
    test "returns error tuple when topic does not exist" do
      assert nil == Topics.get_by_title("3D Renderer")
    end

    test "returns topic when it exists" do
      topic = Factory.insert(:topic)

      topic_from_db = Topics.get_by_title(topic.title)

      assert topic.id == topic_from_db.id
      assert topic.title == topic_from_db.title
    end
  end

  describe "from_topic_data/1" do
    test "returns error tuple for invalid topic data" do
      {:error, :invalid_topic_data} = Topics.from_topic_data({:error, :invalid_topic_data})
    end

    test "returns topic for valid topic data" do
      {:ok, topic} = Topics.from_topic_data({:ok, "3D Renderer"})

      assert {:ok, title_from_db} = get_by_id(topic.id)
      assert title_from_db == topic
    end
  end

  defp get_by_id(id) do
    case Repo.get(Topic, id) do
      nil -> {:error, :not_found}
      topic -> {:ok, topic}
    end
  end

end
