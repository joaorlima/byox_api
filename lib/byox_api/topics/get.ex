defmodule ByoxApi.Topics.Get do

  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic

  import Ecto.Query

  def call(title) do
    case Repo.one(
      from(t in Topic, where: ilike(t.title, ^"%#{title}%"))
    ) do
      [] -> IO.puts("NOTHING")
      t -> {:ok, %Topic{id: t.id, title: t.title} |> Repo.preload(:tutorials)}
    end
  end

end
