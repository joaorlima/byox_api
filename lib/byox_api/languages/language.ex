defmodule ByoxApi.Languages.Language do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:name]

  schema "languages" do
    field :name, :string
  end

  def changeset(topic \\ %__MODULE__{}, params) do
    topic
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 1)
    |> unique_constraint(:name)
  end

end
