defmodule ByoxApiWeb.TopicTest do
  use ByoxApiWeb.ConnCase, async: true

  alias ByoxApi.Content.Language
  alias ByoxApi.Content.Languages
  alias ByoxApi.Content.Topics
  alias ByoxApi.Content.Tutorial

  import Ecto.Query

  describe "queries" do
    test "given existing topic, returns topics info", %{conn: conn} do
      {:ok, topic} = create_topic("Shell")

      query = """
      query {
        topic(title: "Shell") {
          title
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      expected_response = %{
          "data" => %{
            "topic" => [
              %{"title" => "#{topic.title}"},
            ]
          }
        }

      assert expected_response == response
    end

    test "given existing topic allows partial and case-insensitive filtering", %{conn: conn} do
      {:ok, topic_1} = create_topic("Web Server")
      {:ok, topic_2} = create_topic("Web Browser")

      query = """
      query {
        topic(title: "web") {
          title
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      expected_response = %{
          "data" => %{
            "topic" => [
              %{"title" => "#{topic_1.title}"},
              %{"title" => "#{topic_2.title}"},
            ]
          }
        }

      assert expected_response == response
    end

    test "given non-existing topic. should return not found message", %{conn: conn} do
      {:ok, _topic} = create_topic("Shell")

      query = """
      query {
        topic(title: "Game") {
          title
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert_response_contains_error_message(response, "not_found")
    end

    test "query non-existing field for topic, returns an error message", %{conn: conn} do
      {:ok, _topic} = create_topic("Game")

      query = """
      query {
        topic(title: "Git") {
          title
          link
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert_response_contains_error_message(response, "Cannot query field \"link\" on type \"Topic\"")
    end

    test "given existing topics, allows composition of tutorials and languages", %{conn: conn} do
      {:ok, php} = create_language("PHP")
      {:ok, python} = create_language("Python")
      {:ok, rust} = create_language("Rust")

      {:ok, web_server_topic} = create_topic("Web Server")
      {:ok, web_browser_topic} = create_topic("Web Browser")

      {:ok, tutorial_1} = create_tutorial("PHP Server", "https://www.mocked.com/php-server", web_server_topic.id, php.id)
      {:ok, tutorial_2} = create_tutorial("Python Browser", "https://www.mocked.com/py-browser", web_browser_topic.id, python.id)
      {:ok, tutorial_3} = create_tutorial("Rust Browser", "https://www.mocked.com/rs-browser", web_browser_topic.id, rust.id)

      get_language_name_from_tutorial_id(tutorial_1.id)

      query = """
      query {
        topic(title: "Web") {
          title
          tutorials {
            title
            url
            language {
              name
            }
          }
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      expected_response =
        %{
          "data" => %{
            "topic" => [
              %{
                "title" => "#{web_server_topic.title}",
                "tutorials" => [
                  %{
                    "language" => %{"name" => "#{get_language_name_from_tutorial_id(tutorial_1.id)}"},
                    "title" => "#{tutorial_1.title}",
                    "url" => "#{tutorial_1.url}"
                  }
                ]
              },
              %{
                "title" => "#{web_browser_topic.title}",
                "tutorials" => [
                  %{
                    "language" => %{"name" => "#{get_language_name_from_tutorial_id(tutorial_2.id)}"},
                    "title" => "#{tutorial_2.title}",
                    "url" => "#{tutorial_2.url}"
                  },
                  %{
                    "language" => %{"name" => "#{get_language_name_from_tutorial_id(tutorial_3.id)}"},
                    "title" => "#{tutorial_3.title}",
                    "url" => "#{tutorial_3.url}"
                  }
                ]
              }
            ]
          }
        }

      assert expected_response == response
    end

  end

  defp create_language(name), do: %{name: name} |> Languages.create()
  defp create_topic(title), do: %{title: title} |> Topics.create()

  defp create_tutorial(title, url, topic_id, language_id) do
    %{
      title: title,
      url: url,
      topic_id: topic_id,
      language_id: language_id
    } |> ByoxApi.create_tutorial()
  end

  defp get_language_name_from_tutorial_id(tutorial_id) do
    query =
      from t in Tutorial,
      join: l in Language, on: t.language_id == l.id,
      where: t.id == ^tutorial_id,
      select: l.name

    ByoxApi.Repo.one!(query)
  end

  defp assert_response_contains_error_message(response, expected_message) do
    assert %{"errors" => [%{"message" => message}]} = response
    assert String.contains?(message, expected_message)
  end

end
