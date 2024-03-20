defmodule ByoxApi.Content.Languages do

  alias ByoxApi.Repo
  alias ByoxApi.Content.Language

  def create(params) do
    params
    |> Language.changeset()
    |> Repo.insert()
  end

  def get_by_name(name) do
    case Repo.get_by(Language, name: name) do
      nil -> {:error, :not_found}
      language -> {:ok, Repo.preload(language, tutorials: [:topic])}
    end
  end

  def find_or_create(language_name) do
    case get_by_name(language_name) do
      {:error, :not_found} ->
        %{name: language_name}
        |> create()
      {:ok, language} -> {:ok, language}
    end
  end

end
