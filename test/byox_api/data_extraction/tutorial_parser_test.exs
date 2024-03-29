defmodule ByoxApi.DataExtraction.TutorialParserTest do
  use ByoxApi.DataCase

  alias ByoxApi.DataExtraction.TutorialParser

  import ExUnit.CaptureLog

  @mocked_valid_tutorials_tag [
    "<li><a href=\"https://www.mocked.com/rust-git\"><strong>Rust</strong>: <em>Rust Git</em></a></li>",
    "<li><a href=\"https://www.mocked.com/cpp-git\"><strong>C++</strong>: <em>C++ Git</em></a></li>",
    "<li><a href=\"https://www.mocked.com/php-git\"><strong>PHP</strong>: <em>PHP Git</em></a></li>",
  ]

  @mocked_invalid_tutorials_tag [
    "<li><a href=\"https://www.mocked.com/rust-bot\"><strong>Rust</strong>: _Rust Bot</a></li>", # missing closing underscore
    "<li>\n[<strong>Elixir</strong>: <em>Elixir Bot</em>](<a href=\"https://www.mocked.com/ex-bot\">https://www.mocked.com/ex-bot</a></li>", # missing closing parenthesis on url
    "<li><a href=\"https://www.mocked.com/php-bot\"><strong>PHP</strong>: <em>PHP Bot</em></a></li>",
  ]

  describe "parse_tutorial/1" do
    test "extract tutorial info given a valid tutorial tag" do
      tutorials_parsed = TutorialParser.parse_tutorial(@mocked_valid_tutorials_tag)

      assert_tutorial_content_was_parsed(tutorials_parsed, "Rust Git", "https://www.mocked.com/rust-git", "Rust")
      assert_tutorial_content_was_parsed(tutorials_parsed, "C++ Git", "https://www.mocked.com/cpp-git", "C++")
      assert_tutorial_content_was_parsed(tutorials_parsed, "PHP Git", "https://www.mocked.com/php-git", "PHP")
    end

    test "logs an error given a invalid tutorial tag" do
      captured_log = capture_log(fn -> TutorialParser.parse_tutorial(@mocked_invalid_tutorials_tag) end)

      tutorials_parsed = TutorialParser.parse_tutorial(@mocked_invalid_tutorials_tag)

      assert {:error, :invalid_tutorial_data} in tutorials_parsed

      assert captured_log =~ """
      Failed to extract tutorial contents from <li><a href="https://www.mocked.com/rust-bot"><strong>Rust</strong>: _Rust Bot</a></li>.
      """

      assert captured_log =~ """
      Failed to extract tutorial contents from <li>
      [<strong>Elixir</strong>: <em>Elixir Bot</em>](<a href="https://www.mocked.com/ex-bot">https://www.mocked.com/ex-bot</a></li>.
      """

      assert_tutorial_content_was_parsed(tutorials_parsed, "PHP Bot", "https://www.mocked.com/php-bot", "PHP")
    end
  end

  defp assert_tutorial_content_was_parsed(tutorials_parsed, title, url, language) do
    tutorial_data = [
      title: title,
      url: url,
      language: language
    ]

    tutorial_info = {
      :ok,
      %{
        tutorial_data: tutorial_data
      }
    }

    assert tutorial_info in tutorials_parsed
  end
end
