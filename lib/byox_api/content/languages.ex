defmodule ByoxApi.Content.Languages do

  alias ByoxApi.Repo
  alias ByoxApi.Content.Language
  alias ByoxApi.DataExtraction.LanguageParser

  @spec create(params :: map()) :: {:ok, Language.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> Language.changeset()
    |> Repo.insert()
  end

  @spec get_by_name(name :: String.t()) :: {:error, :not_found} | {:ok, Language.t()}
  def get_by_name(name) do
    case Repo.get_by(Language, name: name) do
      nil -> {:error, :not_found}
      language -> {:ok, Repo.preload(language, tutorials: [:topic])}
    end
  end

  def parse_and_create_languages(languages_names) do
    languages_names
    |> LanguageParser.parse_languages_names()
    |> find_or_create_languages()
  end

  defp find_or_create_languages(language_names) do
    language_names
    |> Enum.map(&find_or_create_language/1)
  end

  @spec find_or_create_language(language_name :: String.t()) :: {:error, Ecto.Changeset.t()} | {:ok, Language.t()}
  defp find_or_create_language(language_name) do
    case get_by_name(language_name) do
      {:error, :not_found} ->
        %{name: language_name}
        |> create()
      {:ok, language} ->
        {:ok, language}
    end
  end

end
