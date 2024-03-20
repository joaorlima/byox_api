defmodule ByoxApi do

  alias ByoxApi.Content.Languages
  alias ByoxApi.Content.Topics

  @spec get_language_by_name(name :: String) :: {:ok, Language.t()} | {:error, :not_found}
  defdelegate get_language_by_name(name), to: Languages, as: :get_by_name

  @spec get_topics_by_title(title :: String) :: {:ok, [Topic.t()]} | {:error, :not_found}
  defdelegate get_topics_by_title(title), to: Topics, as: :find_similar_by_title

  @spec find_topic_by_title(title :: String) :: Topic.t() | nil
  defdelegate find_topic_by_title(title), to: Topics, as: :get_by_title
end
