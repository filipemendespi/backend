defmodule Re.Repo.Migrations.DuplicateSchemaMigrations do
  use Ecto.Migration

  def up do
    execute("CREATE TABLE old_schema_migrations AS TABLE schema_migrations;")
  end

  def down, do: drop(table(:old_schema_migrations))
end
