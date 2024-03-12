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

      expected_response = %{
        "data" => %{"language" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "not_found",
            "path" => ["language"]
          }
        ]
      }

      assert expected_response == response
    end
  end

  defp create_language(name) do
    params = %{name: name}
    ByoxApi.create_language(params)
  end
end
