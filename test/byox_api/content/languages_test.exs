defmodule ByoxApi.Content.LanguagesTest do
  use ByoxApi.DataCase

  alias ByoxApi.Content.Language
  alias ByoxApi.Content.Languages
  alias ByoxApi.Factories.SchemaFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "create/1" do
    test "fails to create a language with invalid params" do
      params = %{name: ""}

      assert {:error, %Ecto.Changeset{valid?: false}} = Languages.create(params)
    end

    test "creates a new language with valid params" do
      params = Factory.string_params_for(:language)

      assert {:ok, %Language{} = created_language} = Languages.create(params)

      language_from_db = Repo.get(Language, created_language.id)
      assert created_language == language_from_db
    end
  end

  describe "get_by_name/1" do
    test "returns error tuple when language does not exist" do
      assert {:error, :not_found} = Languages.get_by_name("Elixir")
    end

    test "returns language when it exists" do
      language = Factory.insert(:language)

      {:ok, language_from_db} = Languages.get_by_name(language.name)

      assert language.id == language_from_db.id
      assert language.name == language_from_db.name
    end
  end

  describe "find_or_create/1" do
    test "creates a new language if it doesn't exists" do
      assert get_all_languages() |> Enum.count == 0

      {:ok, language} = Languages.find_or_create("Elixir")
      {:ok, language_from_db} = Languages.get_by_name("Elixir")

      assert language.id == language_from_db.id
      assert language.name == language_from_db.name
    end

    test "does not create a new language if it already exists" do
      created_language = Factory.insert(:language)

      assert get_all_languages() |> Enum.count == 1

      {:ok, language} = Languages.find_or_create("Elixir")

      assert get_all_languages() |> Enum.count == 1
      assert created_language.id == language.id
      assert created_language.name == language.name
    end
  end

  defp get_all_languages(), do: Repo.all(Language)

end
