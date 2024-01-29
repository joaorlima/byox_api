defmodule ByoxApiWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias ByoxApiWeb.Resolvers.Language, as: LanguageResolver

  import_types ByoxApiWeb.Schema.Types.Language
  import_types ByoxApiWeb.Schema.Types.Tutorial

  object :root_query do
    field :language, type: :language do
      arg :name, non_null(:string)

      resolve &LanguageResolver.get/2
    end
  end

end
