defmodule Re.Repo.Migrations.AddListingUuidToUnits do
  use Ecto.Migration

  def up do
    alter table(:units) do
      remove :listing_id
      add :listing_uuid, references(:listings, column: :uuid, type: :uuid)
    end
  end

  def down do
    alter table(:units) do
      remove :listing_uutid
      add :listing_id, references(:listings)
    end
  end
end

