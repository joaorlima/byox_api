defmodule ByoxApi.Topics.Create do
  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic

  def call(params) do
    params
    |> Topic.changeset()
    |> Repo.insert()
  end
end
