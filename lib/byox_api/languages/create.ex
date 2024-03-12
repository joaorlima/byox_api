defmodule ByoxApi.Languages.Create do
  alias ByoxApi.Repo
  alias ByoxApi.Languages.Language

  def create(params) do
    params
    |> Language.changeset()
    |> Repo.insert()
  end
end
