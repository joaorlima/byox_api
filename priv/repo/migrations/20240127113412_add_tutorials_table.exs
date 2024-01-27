defmodule ByoxApi.Repo.Migrations.AddTutorialsTable do
  use Ecto.Migration

  def change do
    create table(:tutorials) do
      add :title, :string
      add :url, :string
      add :topic_id, references(:topics, on_delete: :delete_all)
      add :language_id, references(:languages)
    end

    create unique_index(:tutorials, [:title, :topic_id, :language_id])
    create index(:tutorials, [:topic_id])
    create index(:tutorials, [:language_id])
  end

end
