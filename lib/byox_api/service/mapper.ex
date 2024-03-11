defmodule ByoxApi.Service.Mapper do

  alias ByoxApi.ContentMapper.DataMapper
  alias ByoxApi.ContentMapper.LanguageMapper
  alias ByoxApi.ContentMapper.TopicMapper
  alias ByoxApi.ContentMapper.TutorialMapper

  def sync(url) do
    {:ok, response} = Tesla.get(url)

    html = Earmark.as_html!(response.body)

    {:ok, document} = Floki.parse_document(html)

    ul_tags = Floki.find(document, "ul")

    data =
      for ul_tag <- ul_tags do
        child_nodes = Floki.children(ul_tag)
        Enum.map(child_nodes, &Floki.raw_html/1)
      end

    [topics | tutorial_lists] = data

    # tutorial_lists |> Enum.drop(1)

    mapped_list = Enum.zip(topics, tutorial_lists)

    result_map = Enum.into(mapped_list, %{})

    tutorials_data =
      result_map
      |> Enum.map(fn {category_tag, html_tags} ->
        DataMapper.extract(category_tag, html_tags)
      end)
      |> Map.new()
      |> Map.to_list()

    # create topics
    tutorials_data
    |> Enum.map(&TopicMapper.map_and_create/1)

    # create language
    tutorials_data
    |> LanguageMapper.map_and_create()

    # create tutorials
    tutorials_data
    |> TutorialMapper.map_and_create()

    {:ok}
  end

end
