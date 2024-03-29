defmodule ByoxApi.DataExtraction.HTMLDataExtractorTest do
  use ByoxApiWeb.ConnCase, async: true

  alias ByoxApi.Repo
  alias ByoxApi.Content.Language
  alias ByoxApi.Content.Topic
  alias ByoxApi.Content.Tutorial
  alias ByoxApi.DataExtraction.HTMLDataExtractor

  import ExUnit.CaptureLog
  import Tesla.Mock

  @url "https://raw.mockedcontent.com/mocked.md"

  setup do
    mock(fn env ->
      case env.url do
        @url -> %Tesla.Env{status: 200, body: mocked_body()}
        _ -> %Tesla.Env{status: 404, body: "NotFound"}
      end
    end)
  end

  describe "sync/1" do
    test "given valid url, parses response body and create entities" do
      captured_log = capture_log(fn -> HTMLDataExtractor.sync(@url) end)

      topics = get_all_topics()
      languages = get_all_languages()
      tutorials = get_all_tutorials()

      assert topics |> Enum.count() == 4
      assert languages |> Enum.count() == 7
      assert tutorials |> Enum.count() == 8

      assert_topic_contains_expected_tutorials("3D Renderer", 3)
      assert_topic_contains_expected_tutorials("Augmented Reality", 1)
      assert_topic_contains_expected_tutorials("Bot", 3)
      assert_topic_contains_expected_tutorials("Docker", 1) # Go Container tutorial contains an error, so it won't be inserted

      assert captured_log =~ "Failed to extract topic from <li>\n[Git(#mocked-git)  </li>"
      assert captured_log =~ "Failed to extract tutorial contents from <li><a href=\"https://www.mocked.com/go-docker\"><strong>Go</strong>: _Go Container</a></li"
    end

    test "returns error message for invalid url" do
      captured_log = capture_log(fn -> HTMLDataExtractor.sync("https://invalid.url.com") end)

      assert captured_log =~ "Error occurred while processing the response. Unable to extract data"
    end
  end

  defp mocked_body do
    """
    ## Table of Mocked Contents

    Compilation of guides for re-creating our favorite technologies from scratch.

    * [3D Renderer](#mocked-3d-renderer)
    * [Augmented Reality](#mocked-aug-reality)
    * [Bot](#mocked-bot)
    * [Git(#mocked-git)
    * [Docker](#mocked-docker)

    ## Tutorials

    #### Mocked `3D Renderer`

    * [**C++**: _3D Renderer Tutorial_](https://www.mocked.com/3d-rend)
    * [**Java / JavaScript**: _3D Engine_](https://www.mocked.com/3d-engine)

    #### Mocked `Augmented Reality`

    * [**PHP**: _Augmented Reality Tutorial_](https://www.mocked.com/aug-reality)

    #### Mocked `Bot`

    * [**Python**: _Python Bot_](https://www.mocked.com/py-bot)
    * [**Elixir**: _Elixir Bot_](https://www.mocked.com/ex-bot)
    * [**PHP**: _PHP Bot_](https://www.mocked.com/php-bot)

    #### Mocked `Git`

    * [**Rust**: _Rust Git_](https://www.mocked.com/rust-git)

    #### Mocked `Docker`

    * [**C**: _Docker in C_](https://www.mocked.com/c-docker)
    * [**Go**: _Go Container](https://www.mocked.com/go-docker)

    ## Contribute
    * Submissions welcome
    """
  end

  defp get_all_languages, do: Repo.all(Language)
  defp get_all_topics, do: Repo.all(Topic)
  defp get_all_tutorials, do: Repo.all(Tutorial)

  defp assert_topic_contains_expected_tutorials(topic_name, number_of_tutorials) do
    case ByoxApi.find_topic_by_title(topic_name) do
      nil -> :error
      topic ->
        assert topic.tutorials |> Enum.count() == number_of_tutorials
    end
  end

end
