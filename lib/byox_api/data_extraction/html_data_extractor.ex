defmodule ByoxApi.DataExtraction.HTMLDataExtractor do

  alias ByoxApi.DataExtraction.ContentMapper

  require Logger

  def sync(url) do
    {:ok, response} = Tesla.get(url)

    html = Earmark.as_html!(response.body)

    {:ok, document} = Floki.parse_document(html)

    ul_tags = Floki.find(document, "ul")

    data = extract_data_from_ul_tags(ul_tags)

    Logger.info("Extracting data...")

    data
    |> create_content_map()
    |> ContentMapper.extract()

    :ok
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
