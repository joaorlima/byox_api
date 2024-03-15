defmodule ByoxApi.Topics.Factory do

  alias ByoxApi.Topics.Topic

  @spec create(params :: {:error, :invalid_topic_data} | {:ok, String.t()}) :: {:error, Ecto.Changeset.t()} | {:ok, Topic.t()}
  def create({:error, _}), do: {:error, :rename_this}
  def create({:ok, topic_title}) do
    %{
      title: topic_title
    } |> ByoxApi.create_topic()
  end

end
