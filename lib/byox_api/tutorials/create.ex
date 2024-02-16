defmodule ByoxApi.Tutorials.Create do
  alias ByoxApi.Repo
  alias ByoxApi.Tutorials.Tutorial

  def call(params) do
    params
    |> Tutorial.changeset()
    |> Repo.insert()
  end
end
