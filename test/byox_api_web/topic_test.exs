defmodule ByoxApiWeb.TopicTest do
  use ByoxApiWeb.ConnCase, async: true

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

      expected_response = %{
        "data" => %{"topic" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "not_found",
            "path" => ["topic"]
          }
        ]
      }

      assert expected_response == response
    end
  end

  defp create_topic(title), do: %{title: title} |> ByoxApi.create_topic()
end
