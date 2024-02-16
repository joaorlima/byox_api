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

    test "given non-existing language. should not return the language", %{conn: conn} do
      {:ok, _language} = create_language("Elixir")

      query = """
      query {
        language(name: "PHP") {
          name
        }
      }
      """

      assert_error_sent 404, fn ->
        conn
        |> post("/api/graphql", %{query: query})
      end
    end
  end

  defp create_language(name) do
    params = %{name: name}
    ByoxApi.create_language(params)
  end
end
