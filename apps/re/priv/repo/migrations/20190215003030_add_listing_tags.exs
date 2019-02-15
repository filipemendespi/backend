defmodule Re.Repo.Migrations.AddListingTags do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :tags, {:array, :map}, default: []
    end
  end
end
