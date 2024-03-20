defmodule ByoxApi.DataExtraction.TopicParserTest do
  use ByoxApi.DataCase

  alias ByoxApi.DataExtraction.TopicParser

  import ExUnit.CaptureLog

  @mocked_valid_topic_tag "<li><a href=\"#mocked-game\">Game</a></li>"
  @mocked_invalid_topic_tag "<li>\n[Git(#mocked-git)  </li>"

  describe "parse_topic_data/1" do
    test "extract topic info given a valid topic tag" do
      {:ok, "Game"} = TopicParser.parse_topic_data(@mocked_valid_topic_tag)
    end

    test "logs an error given an invalid topic tag" do
      captured_log = capture_log(fn -> TopicParser.parse_topic_data(@mocked_invalid_topic_tag) end)

      {:error, :invalid_topic_data} = TopicParser.parse_topic_data(@mocked_invalid_topic_tag)
      assert captured_log =~ "Failed to extract topic from <li>\n[Git(#mocked-git)  </li>."
    end
  end
end
