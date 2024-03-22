defmodule ByoxApi.DataExtraction.LanguageParserTest do
  use ByoxApi.DataCase

  alias ByoxApi.DataExtraction.LanguageParser

  describe "parse_languages_names/1" do
    test "split languages names when there are multiple ones" do
      languages = LanguageParser.parse_languages_names("C / C++ / C#")

      assert languages == ["C", "C++", "C#"]
      assert languages |> Enum.count() == 3
    end

    test "returns language name when there's a single one" do
      languages = LanguageParser.parse_languages_names("Elixir")

      assert languages == ["Elixir"]
      assert languages |> Enum.count() == 1
    end
  end

end
