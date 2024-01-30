defmodule ByoxApi.Languages.Get do

  alias ByoxApi.Repo
  alias ByoxApi.Languages.Language

  def call(name) do
    case Repo.get_by!(Language, name: name) do
      nil -> {:error, :not_found}
      language -> language |> create_language_struct()
    end
  end

  defp create_language_struct(language) do
    %Language{id: language.id, name: language.name}
  end

end
