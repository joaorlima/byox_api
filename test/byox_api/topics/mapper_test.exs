defmodule ByoxApi.Topics.MapperTest do
  use ByoxApi.DataCase

  alias ByoxApi.Topics.Mapper

  import ExUnit.CaptureLog

  @mocked_valid_topic_tag "<li><a href=\"#mocked-game\">Game</a></li>"
  @mocked_invalid_topic_tag "<li>\n[Git(#mocked-git)  </li>"

  describe "map/1" do
    test "extract topic info given a valid topic tag" do
      {:ok, "Game"} = Mapper.map(@mocked_valid_topic_tag)
    end

    test "logs an error given an invalid topic tag" do
      captured_log = capture_log(fn -> Mapper.map(@mocked_invalid_topic_tag) end)

      {:error, :invalid_topic_data} = Mapper.map(@mocked_invalid_topic_tag)
      assert captured_log =~ "Failed to extract topic from <li>\n[Git(#mocked-git)  </li>."
    end
  end

end
