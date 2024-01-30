defmodule ByoxApi.Sync do

  alias ByoxApi.Sync.Helper.ExtractOverallData
  alias ByoxApi.Sync.Helper.ExtractTopics
  alias ByoxApi.Sync.Helper.ExtractTutorials
  alias ByoxApi.Sync.Helper.ExtractLanguages

  def sync do
    response = Req.get!("https://raw.githubusercontent.com/codecrafters-io/build-your-own-x/master/README.md")

    html = Earmark.as_html!(response.body)

    {:ok, document} = Floki.parse_document(html)

    ul_tags = Floki.find(document, "ul")

    data = for ul_tag <- ul_tags do
      child_nodes = Floki.children(ul_tag)
      Enum.map(child_nodes, &Floki.raw_html/1)
    end

    [topics | tutorial_lists] = data

    tutorial_lists |> Enum.drop(1)

    mapped_list = Enum.zip(topics, tutorial_lists)

    result_map = Enum.into(mapped_list, %{})

    tutorials_data =
      result_map
      |> Enum.map(fn {category_tag, html_tags} -> ExtractOverallData.extract(category_tag, html_tags) end)
      |> Map.new()
      |> Map.to_list()

    # create topics
    tutorials_data
    |> Enum.map(&ExtractTopics.map_and_create/1)

    # create language
    tutorials_data
    |> ExtractLanguages.map_and_create()

    # create tutorials
    tutorials_data
    |> ExtractTutorials.map_and_create()
  end

end
