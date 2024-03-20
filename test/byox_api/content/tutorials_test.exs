defmodule ByoxApi.Content.TutorialsTest do
  use ByoxApi.DataCase

  alias ByoxApi.Content.Tutorial
  alias ByoxApi.Content.Tutorials
  alias ByoxApi.Content.Languages
  alias ByoxApi.Factories.SchemaFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "create/1" do
    test "fails to create a tutorial with invalid params" do
      params = %{title: "Web Server"}

      assert {:error, %Ecto.Changeset{valid?: false}} = Tutorials.create(params)
    end

    test "creates a new tutorial with valid params" do
      Factory.insert(:language)
      Factory.insert(:topic)

      params = Factory.string_params_for(:tutorial)

      assert {:ok, %Tutorial{} = created_tutorial} = Tutorials.create(params)

      tutorial_from_db = Repo.get(Tutorial, created_tutorial.id)
      assert created_tutorial == tutorial_from_db
    end
  end

  describe "from_tutorial_data/2" do
    test "returns error tuple for invalid tutorial data" do
      {:error, :invalid_topic} = Tutorials.from_tutorial_data([], {:error, :invalid_topic_data})
      {:error, :invalid_tutorial} = Tutorials.from_tutorial_data({:error, :invalid_tutorial_data}, %{})
    end

    test "returns tutorial for valid tutorial data" do
      topic = Factory.insert(:topic)

      tutorial_data = {
        :ok,
        %{
          tutorial_data: [
            title: "3D Renderer Tutorial",
            url: "https://www.mocked.com/3d-rend",
            language: "C++"
          ]
        }
      }

      assert {:ok, tutorial} = Tutorials.from_tutorial_data(tutorial_data, {:ok, topic})

      {:ok, language} = Languages.get_by_name("C++")

      assert tutorial.title == "3D Renderer Tutorial"
      assert tutorial.url == "https://www.mocked.com/3d-rend"
      assert tutorial.topic_id == topic.id
      assert tutorial.language_id == language.id
    end
  end

end
