defmodule ByoxApi.Repo.Migrations.AddTopicsTable do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :string
    end

    create unique_index(:topics, [:title])
  end
end
