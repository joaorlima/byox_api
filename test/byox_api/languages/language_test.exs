defmodule ByoxApi.Languages.LanguageTest do
  use ByoxApiWeb.ConnCase, async: true

  alias ByoxApi.Languages.Language

  import AntlUtilsEcto.Changeset

  describe "changeset/2" do
    test "invalid changeset with missing name" do
      params = %{}
      changeset = Language.changeset(%Language{}, params)

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "valid changeset" do
      params = %{name: "Elixir"}
      changeset = Language.changeset(%Language{}, params)

      assert changeset.valid?
    end
  end
end
