defmodule ReTags.Repo.Migrations.CreateTagProjections do
  use Ecto.Migration

  def change do
    create table(:tag_projections, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :visibility, :string

      timestamps()
    end
  end
end
