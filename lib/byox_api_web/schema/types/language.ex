defmodule ByoxApiWeb.Schema.Types.Language do
  use Absinthe.Schema.Notation

  object :language do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :tutorials, list_of(:tutorial)
  end

end
