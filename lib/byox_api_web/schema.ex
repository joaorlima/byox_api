defmodule ByoxApiWeb.Schema do
  use Absinthe.Schema

  import_types ByoxApiWeb.Schema.Types.Root

  query do
    import_fields :root_query
  end
end
