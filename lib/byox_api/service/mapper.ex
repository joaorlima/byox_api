defmodule ByoxApi.Service.Mapper do

  alias ByoxApi.Service.TopicMapper
  alias ByoxApi.Service.TutorialMapper

  require Logger

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

    Logger.info("Extracting data...")

    result_map
    |> TopicMapper.extract()

    result_map
    |> TutorialMapper.extract()

    {:ok}
  end

end
