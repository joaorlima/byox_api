defmodule ByoxApi.Repo.Migrations.AddLanguagesTable do
  use Ecto.Migration

  def change do
    create table(:languages) do
      add :name, :string
    end

    create unique_index(:languages, [:name])
  end

end
