defmodule ByoxApiWeb.Schema.Types.Topic do
  use Absinthe.Schema.Notation

  object :topic do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :tutorials, list_of(:tutorial)
  end

end
