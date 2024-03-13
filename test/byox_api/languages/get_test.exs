defmodule ByoxApi.Languages.GetTest do
  use ByoxApi.DataCase

  alias ByoxApi.Languages.Get
  alias ByoxApi.Factories.SchemaFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "get_by_name/1" do
    test "returns error tuple when language does not exist" do
      assert {:error, :not_found} = Get.get_by_name("Elixir")
    end

    test "returns language when it exists" do
      language = Factory.insert(:language)

      {:ok, language_from_db} = Get.get_by_name(language.name)

      assert language.id == language_from_db.id
      assert language.name == language_from_db.name
    end
  end

end
