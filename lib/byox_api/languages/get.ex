defmodule ByoxApi.Languages.Get do

  alias ByoxApi.Repo
  alias ByoxApi.Languages.Language

  import Ecto.Query

  def call(name) do
    case Repo.one(
      from(l in Language, where: ilike(l.name, ^"%#{name}%"))
    ) do
      nil -> {:error, :not_found}
      l -> {:ok, %Language{id: l.id, name: l.name} |> Repo.preload(:tutorials)}
    end
  end

end
