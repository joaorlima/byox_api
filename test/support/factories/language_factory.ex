defmodule ByoxApi.Factories.LanguageFactory do
  use ExMachina.Ecto, repo: ByoxApi.Repo

  alias ByoxApi.Languages.Language

  def language_factory do
    %Language{
      name: "Elixir"
    }
  end

end
