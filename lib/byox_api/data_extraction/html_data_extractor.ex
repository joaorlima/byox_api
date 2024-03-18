defmodule ByoxApi.DataExtraction.HTMLDataExtractor do

  alias ByoxApi.DataExtraction.ContentMapper

  require Logger

  def sync(url) do
    url
    |> Tesla.get()
    |> handle_response()
    |> process_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 404}}), do: {:error, :not_found}
  defp handle_response({:ok, %Tesla.Env{} = response}), do: {:ok, response}

  defp process_response({:error, :not_found}), do: log_error_message()
  defp process_response({:ok, response}) do
    html = Earmark.as_html!(response.body)

    {:ok, document} = Floki.parse_document(html)

    ul_tags = Floki.find(document, "ul")

    data = extract_data_from_ul_tags(ul_tags)

    Logger.info("Extracting data...")

    data
    |> create_content_map()
    |> ContentMapper.extract()
  end

  defp log_error_message() do
    Logger.error("Error occurred while processing the response. Unable to extract data")
  end

  defp extract_data_from_ul_tags(ul_tags) do
    ul_tags
    |> Enum.map(fn ul_tag ->
      child_nodes = Floki.children(ul_tag)
      Enum.map(child_nodes, &Floki.raw_html/1)
    end)
  end

  defp create_content_map(data) do
    [topics | tutorial_lists] = data
    mapped_list = Enum.zip(topics, tutorial_lists)

    Enum.into(mapped_list, %{})
  end

end
