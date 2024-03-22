defmodule ByoxApi.DataExtraction.LanguageParser do

  def parse_languages_names(language_name) do
    language_name
    |> extract_languages_names_from_tag()
  end

  defp extract_languages_names_from_tag(language_name) do
    case String.contains?(language_name, "/") do
      true -> split_languages_by_slash(language_name)
      _ -> [language_name]
    end
  end

  defp split_languages_by_slash(language_name) do
    String.split(language_name, "/", trim: true)
    |> Enum.map(&String.trim/1)
  end

end
