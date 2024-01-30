defmodule ByoxApiWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias ByoxApiWeb.Resolvers.Language, as: LanguageResolver
  alias ByoxApiWeb.Resolvers.Topic, as: TopicResolver
  alias Crudry.Middlewares.TranslateErrors, as: TE

  import_types ByoxApiWeb.Schema.Types.Language
  import_types ByoxApiWeb.Schema.Types.Tutorial
  import_types ByoxApiWeb.Schema.Types.Topic

  object :root_query do
    field :language, type: :language do
      arg :name, non_null(:string)

      resolve &LanguageResolver.get/2
      middleware TE
    end

    field :topic, type: list_of(:topic) do
      arg :title, non_null(:string)

      resolve &TopicResolver.get/2
      middleware TE
    end

  end

end
