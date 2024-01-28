defmodule ByoxApi do

  alias ByoxApi.Languages
  alias ByoxApi.Tutorials
  alias ByoxApi.Topics

  defdelegate create_language(params), to: Languages.Create, as: :call
  defdelegate create_topic(params), to: Topics.Create, as: :call
  defdelegate create_tutorial(params), to: Tutorials.Create, as: :call
  defdelegate get_language_by_name(name), to: Languages.Get, as: :call

end
