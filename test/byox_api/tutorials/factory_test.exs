defmodule ByoxApi.Tutorials.FactoryTest do
  use ByoxApi.DataCase

  alias ByoxApi.Tutorials.Factory
  alias ByoxApi.Factories.SchemaFactory

  describe "create/2" do
    test "returns tutorial for valid input" do
      topic = SchemaFactory.insert(:topic)

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

      assert {:ok, tutorial} = Factory.create(tutorial_data, {:ok, topic})

      {:ok, language} = find_language_by_name("C++")

      assert tutorial.title == "3D Renderer Tutorial"
      assert tutorial.url == "https://www.mocked.com/3d-rend"
      assert tutorial.topic_id == topic.id
      assert tutorial.language_id == language.id
    end

    test "returns error tuple for invalid inputs" do
      {:error, :invalid_topic} = Factory.create([], {:error, :invalid_topic_data})
      {:error, :invalid_tutorial} = Factory.create({:error, :invalid_tutorial_data}, %{})
    end
  end

  defp find_language_by_name(name), do: ByoxApi.get_language_by_name(name)

end
