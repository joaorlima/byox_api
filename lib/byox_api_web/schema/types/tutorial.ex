defmodule ByoxApiWeb.Schema.Types.Tutorial do
  use Absinthe.Schema.Notation

  object :tutorial do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :url, non_null(:string)
    field :topic_id, non_null(:id)
    field :language, non_null(:language)
  end
end
