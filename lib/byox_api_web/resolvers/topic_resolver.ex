defmodule ByoxApiWeb.Resolvers.Topic do
  def get(%{title: title}, _context), do: ByoxApi.get_topic_by_title(title)
end
