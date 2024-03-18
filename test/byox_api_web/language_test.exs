defmodule ByoxApiWeb.LanguageTest do
  use ByoxApiWeb.ConnCase, async: true

  describe "queries" do
    test "given existing language. should return the language", %{conn: conn} do
      {:ok, _language} = create_language("Elixir")

      query = """
      query {
        language(name: "Elixir") {
          name
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      expected_response = %{
        "data" => %{
          "language" => %{
            "name" => "Elixir"
          }
        }
      }

      assert expected_response == response
    end

    test "given non-existing language. should return not found message", %{conn: conn} do
      {:ok, _language} = create_language("Elixir")

      query = """
      query {
        language(name: "PHP") {
          name
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert_response_contains_error_message(response, "not_found")
    end

    test "query non-existing field for language, returns an error message", %{conn: conn} do
      {:ok, _language} = create_language("Elixir")

      query = """
      query {
        language(name: "Elixir") {
          title
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert_response_contains_error_message(response, "Cannot query field \"title\" on type \"Language\"")
    end
  end

  defp create_language(name), do: %{name: name} |> ByoxApi.create_language()

  defp assert_response_contains_error_message(response, expected_message) do
    assert %{"errors" => [%{"message" => message}]} = response
    assert String.contains?(message, expected_message)
  end

end
