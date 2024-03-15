defmodule ByoxApi.Languages.FactoryTest do
  use ByoxApi.DataCase

  alias ByoxApi.Repo
  alias ByoxApi.Languages.Factory
  alias ByoxApi.Languages.Language
  alias ByoxApi.Factories.SchemaFactory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "find_or_create/1" do
    test "creates a new language if it doesn't exists" do
      assert get_all_languages() |> Enum.count == 0

      {:ok, language} = Factory.find_or_create("Elixir")
      {:ok, language_from_db} = ByoxApi.get_language_by_name("Elixir")

      assert language.id == language_from_db.id
      assert language.name == language_from_db.name
    end

    test "does not create a new language if it already exists" do
      created_language = SchemaFactory.insert(:language)

      assert get_all_languages() |> Enum.count == 1

      {:ok, language} = Factory.find_or_create("Elixir")

      assert get_all_languages() |> Enum.count == 1
      assert created_language.id == language.id
      assert created_language.name == language.name
    end
  end

  defp get_all_languages(), do: Repo.all(Language)

end
