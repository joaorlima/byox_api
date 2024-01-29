defmodule ByoxApi.Topics.Get do

  alias ByoxApi.Repo
  alias ByoxApi.Topics.Topic

  def call(title) do
    case Repo.get_by(Topic, title: title) do
      nil -> {:error, :not_found}
      topic -> {:ok, Repo.preload(topic, :tutorials)}
    end
  end

end
