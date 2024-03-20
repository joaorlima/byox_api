defmodule ByoxApi.Tutorials.Create do
  alias ByoxApi.Repo
  alias ByoxApi.Content.Tutorial

  def create(params) do
    params
    |> Tutorial.changeset()
    |> Repo.insert()
  end
end
