defmodule ByoxApi.Repo.Migrations.ChangeTutorialsUniqueIndex do
  use Ecto.Migration

  def up do
    execute("DROP INDEX IF EXISTS tutorials_title_topic_id_language_id_index;")
    execute("CREATE UNIQUE INDEX tutorials_title_url_topic_id_language_id_index ON tutorials (title, url, topic_id, language_id);")
  end

  def down do
    execute("DROP INDEX IF EXISTS tutorials_title_topic_id_language_id_index;")
    execute("CREATE UNIQUE INDEX tutorials_title_url_topic_id_language_id_index ON tutorials (title, topic_id, language_id);")
  end

end
