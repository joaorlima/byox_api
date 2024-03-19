defmodule ByoxApi.Languages.Get do
  alias ByoxApi.Repo
  alias ByoxApi.Languages.Language

  def get_by_name(name) do
    case Repo.get_by(Language, name: name) do
      nil -> {:error, :not_found}
      language -> {:ok, Repo.preload(language, tutorials: [:topic])}
    end
  end
end
