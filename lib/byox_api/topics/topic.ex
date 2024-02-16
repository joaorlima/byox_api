defmodule ByoxApi.Topics.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  alias ByoxApi.Tutorials.Tutorial

  @required_params [:title]

  schema "topics" do
    field :title, :string
    has_many :tutorials, Tutorial
  end

  def changeset(topic \\ %__MODULE__{}, params) do
    topic
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:title, min: 2)
    |> unique_constraint(:title)
  end
end
