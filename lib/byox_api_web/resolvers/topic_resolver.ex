defmodule ByoxApiWeb.Resolvers.Topic do
  def get(%{title: title}, _context), do: ByoxApi.get_topics_by_title(title)
end
