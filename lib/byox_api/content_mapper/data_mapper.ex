defmodule ByoxApi.ContentMapper.DataMapper do
  def extract(category_tag, html_tags) do
    category = extract_category_text(category_tag)
    tutorials = Enum.map(html_tags, &parse_tag/1)
    {category, tutorials}
  end

  defp extract_category_text(category_tag) do
    case Regex.run(~r{<a href="#[^>]+">(?<category>[^<]+)</a>}, category_tag,
           capture: [:category]
         ) do
      [category] -> category
      _ -> nil
    end
  end

  defp parse_tag(tag) do
    case Regex.run(
           ~r{<a href="(?<url>[^"]+)"><strong>(?<language>[^<]+)</strong>: <em>(?<title>[^<]+)</em></a>},
           tag,
           capture: [:url, :language, :title]
         ) do
      [url, language, title] -> %{url: url, language: language, title: title}
      _ -> nil
    end
  end
end
