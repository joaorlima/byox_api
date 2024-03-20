defmodule ByoxApi do

  alias ByoxApi.Content.Language
  alias ByoxApi.Content.Languages
  alias ByoxApi.Content.Topic
  alias ByoxApi.Content.Topics

  @spec get_language_by_name(name :: String.t()) :: {:ok, Language.t()} | {:error, :not_found}
  defdelegate get_language_by_name(name), to: Languages, as: :get_by_name

  @spec get_topics_by_title(title :: String.t()) :: {:ok, [Topic.t()]} | {:error, :not_found}
  defdelegate get_topics_by_title(title), to: Topics, as: :find_similar_by_title

  @spec find_topic_by_title(title :: String.t()) :: Topic.t() | nil
  defdelegate find_topic_by_title(title), to: Topics, as: :get_by_title
end
