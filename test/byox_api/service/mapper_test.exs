defmodule ByoxApi.Service.MapperTest do
  use ByoxApiWeb.ConnCase, async: true

  alias ByoxApi.Repo
  alias ByoxApi.Languages.Language
  alias ByoxApi.Topics.Topic
  alias ByoxApi.Tutorials.Tutorial
  alias ByoxApi.Service.Mapper

  import Tesla.Mock

  @url "https://raw.mockedcontent.com/mocked.md"

  setup do
    mock(fn %{method: :get, url: @url} ->
      %Tesla.Env{status: 200, body: mocked_body()}
    end)
  end

  test "parses response body and create entities" do
    {:ok, _response} = Tesla.get(@url)

    Mapper.sync(@url)

    topics = get_all_topics()
    languages = get_all_languages()
    tutorials = get_all_tutorials()

    assert topics |> Enum.count() == 3
    assert languages |> Enum.count() == 4
    assert tutorials |> Enum.count() == 5
  end

  defp mocked_body do
    """
    ## Table of Mocked Contents

    Compilation of guides for re-creating our favorite technologies from scratch.

    * [3D Renderer](#mocked-3d-renderer)
    * [Augmented Reality](#mocked-aug-reality)
    * [Bot](#mocked-bot)

    ## Tutorials

    #### Mocked `3D Renderer`

    * [**C++**: _3D Renderer Tutorial_](https://www.mocked.com/3d-rend)

    #### Mocked `Augmented Reality`

    * [**PHP**: _Augmented Reality Tutorial_](https://www.mocked.com/aug-reality)

    #### Mocked `Bot`

    * [**Python**: _Python Bot_](https://www.mocked.com/py-bot)
    * [**Elixir**: _Elixir Bot_](https://www.mocked.com/ex-bot)
    * [**PHP**: _PHP Bot_](https://www.mocked.com/php-bot)

    ## Contribute
    * Submissions welcome
    """
  end

  defp get_all_languages, do: Repo.all(Language)
  defp get_all_topics, do: Repo.all(Topic)
  defp get_all_tutorials, do: Repo.all(Tutorial)

end
