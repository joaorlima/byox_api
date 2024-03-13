defmodule ByoxApi.Topics.CreateTest do
  use ByoxApi.DataCase

  alias ByoxApi.Topics.Topic
  alias ByoxApi.Topics.Create
  alias ByoxApi.Factories.SchemaFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "create/1" do
    test "fails to create a topic with invalid params" do
      params = %{title: ""}

      assert {:error, %Ecto.Changeset{valid?: false}} = Create.create(params)
    end

    test "creates a new topic with valid params" do
      params = Factory.string_params_for(:topic)

      assert {:ok, %Topic{} = created_topic} = Create.create(params)

      topic_from_db = Repo.get(Topic, created_topic.id)
      assert created_topic == topic_from_db
    end
  end

end
