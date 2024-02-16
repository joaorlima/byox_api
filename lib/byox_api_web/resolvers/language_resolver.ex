defmodule ByoxApiWeb.Resolvers.Language do
  def get(%{name: name}, _context), do: ByoxApi.get_language_by_name(name)
end
