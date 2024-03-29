defmodule ByoxApi.Content.Tutorial do
  use Ecto.Schema
  import Ecto.Changeset

  alias ByoxApi.Content.Language
  alias ByoxApi.Content.Topic

  @type t :: %__MODULE__{
    id: integer(),
    title: String.t(),
    url: String.t(),
    topic: Topic.t(),
    language: Language.t(),
  }

  @required_params [:title, :url, :topic_id, :language_id]

  schema "tutorials" do
    field :title, :string
    field :url, :string

    belongs_to :topic, Topic
    belongs_to :language, Language
  end

  def changeset(tutorial \\ %__MODULE__{}, params) do
    tutorial
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:title, min: 5, max: 255)
    |> foreign_key_constraint(:topic_id)
    |> unique_constraint(:topic_id)
    |> foreign_key_constraint(:language_id)
  end
end
