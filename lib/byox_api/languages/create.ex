defmodule ByoxApi.Languages.Create do
  alias ByoxApi.Repo
  alias ByoxApi.Content.Language

  def create(params) do
    params
    |> Language.changeset()
    |> Repo.insert()
  end
end
