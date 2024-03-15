defmodule ByoxApi.Tutorials.Mapper do

  require Logger

  def map(tutorials_data) do
    tutorials_data
    |> Enum.map(&extract_tutorial_info_from_tag/1)
  end

  def extract_tutorial_info_from_tag(tutorial_data) do
    case Regex.run(
      ~r{<a href="(?<url>[^"]+)"><strong>(?<language>[^<]+)</strong>: <em>(?<title>[^<]+)</em></a>},
      tutorial_data,
      capture: [:url, :language, :title]
      ) do
      [url, language, title] ->
        {:ok, %{tutorial_data: [title: title, url: url, language: language]}}
      _ ->
        log_error_message(tutorial_data)
        {:error, :invalid_tutorial_data}
    end
  end

  defp log_error_message(tutorial_data) do
    """
    Failed to extract tutorial contents from #{tutorial_data}.
    Check for missing tags or closing underscores.
    """
    |> Logger.error()
  end

end
