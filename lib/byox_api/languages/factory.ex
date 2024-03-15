defmodule ByoxApi.Languages.Factory do

  def find_or_create(language_name) do
    case ByoxApi.get_language_by_name(language_name) do
      {:error, :not_found} ->
        %{name: language_name}
        |> ByoxApi.create_language()
      {:ok, language} -> {:ok, language}
    end
  end

end
