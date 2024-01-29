defmodule ByoxApi.Topics.Get do

  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic

  import Ecto.Query

  def call(title) do
    case Repo.one(
      from(t in Topic, where: ilike(t.title, ^"%#{title}%"))
    ) do
      nil -> {:error, :not_found}
      t -> {:ok, %Topic{id: t.id, title: t.title} |> Repo.preload(:tutorials)}
    end
  end

end
