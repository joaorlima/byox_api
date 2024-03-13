defmodule ByoxApi.Topics.GetTest do
  use ByoxApi.DataCase

  alias ByoxApi.Topics.Get
  alias ByoxApi.Factories.SchemaFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "get_by_title/1" do
    test "returns error tuple when topic does not exist" do
      assert {:error, :not_found} = Get.find_similar_by_title("3D Renderer")
    end

    test "returns topic when it exists" do
      language = Factory.insert(:topic)

      {:ok, languages_from_db} = Get.find_similar_by_title(language.title)

      matching_language = languages_from_db |> List.first()

      assert language.id == matching_language.id
      assert language.title == matching_language.title
    end
  end

end
