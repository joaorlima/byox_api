defmodule ByoxApi.Service.TopicMapperTest do
  use ByoxApi.DataCase

  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic
  alias ByoxApi.Service.TopicMapper

  import ExUnit.CaptureLog

  @mocked_data_with_all_valid_topics %{
    "<li><a href=\"#mocked-game\">Game</a></li>" => "_",
    "<li><a href=\"#mocked-shell\">Shell</a></li>" => "_",
    "<li><a href=\"#mocked-browser\">Web Browser</a></li>" => "_",
  }

  @mocked_data_with_a_invalid_topic %{
    "<li>\n[Game(#mocked-game)  </li>" => "_",
    "<li><a href=\"#mocked-shell\">Shell</a></li>" => "_",
    "<li><a href=\"#mocked-Git\">Git</a></li>" => "_"
  }

  describe "extract/1" do
    test "creates topics given valid content" do
      TopicMapper.extract(@mocked_data_with_all_valid_topics)

      topics = get_all_topics()

      game_topic_from_db = ByoxApi.find_topic_by_title("Game")
      shell_topic_from_db = ByoxApi.find_topic_by_title("Shell")
      web_browser_topic_from_db = ByoxApi.find_topic_by_title("Web Browser")

      assert topics |> Enum.count() == 3

      assert game_topic_from_db != nil
      assert shell_topic_from_db != nil
      assert web_browser_topic_from_db != nil
    end

    test "creates a topic for valid contents and log errors for invalid content" do
      captured_log = capture_log(fn -> :ok = TopicMapper.extract(@mocked_data_with_a_invalid_topic) end)

      topics = get_all_topics()
      game_topic_from_db = ByoxApi.find_topic_by_title("Game")
      shell_topic_from_db = ByoxApi.find_topic_by_title("Shell")
      git_topic_from_db = ByoxApi.find_topic_by_title("Git")

      assert topics |> Enum.count() == 2

      assert git_topic_from_db != nil
      assert shell_topic_from_db != nil
      assert game_topic_from_db == nil

      assert captured_log =~ "Failed to extract topic from <li>\n[Game(#mocked-game)  </li>"
    end
  end

  defp get_all_topics, do: Repo.all(Topic)

end
