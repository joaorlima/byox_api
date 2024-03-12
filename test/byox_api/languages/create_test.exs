defmodule ByoxApi.Languages.CreateTest do
  use ByoxApi.DataCase

  alias ByoxApi.Languages.Language
  alias ByoxApi.Languages.Create
  alias ByoxApi.Factories.LanguageFactory, as: Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(ByoxApi.Repo)
  end

  describe "create/1" do
    test "fails to create a language with invalid params" do
      params = %{name: ""}

      assert {:error, %Ecto.Changeset{valid?: false}} = Create.create(params)
    end

    test "creates a new language with valid params" do
      params = Factory.string_params_for(:language)

      assert {:ok, %Language{} = created_language} = Create.create(params)

      language_from_db = Repo.get(Language, created_language.id)
      assert created_language == language_from_db
    end
  end

end
