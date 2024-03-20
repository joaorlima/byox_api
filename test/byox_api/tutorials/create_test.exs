defmodule ByoxApi.Tutorials.CreateTest do
  use ByoxApi.DataCase

  alias ByoxApi.Content.Tutorial
  alias ByoxApi.Tutorials.Create
  alias ByoxApi.Factories.SchemaFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "create/1" do
    test "fails to create a tutorial with invalid params" do
      params = %{title: "Web Server"}

      assert {:error, %Ecto.Changeset{valid?: false}} = Create.create(params)
    end

    test "creates a new tutorial with valid params" do
      Factory.insert(:language)
      Factory.insert(:topic)

      params = Factory.string_params_for(:tutorial)

      assert {:ok, %Tutorial{} = created_tutorial} = Create.create(params)

      tutorial_from_db = Repo.get(Tutorial, created_tutorial.id)
      assert created_tutorial == tutorial_from_db
    end
  end

end
