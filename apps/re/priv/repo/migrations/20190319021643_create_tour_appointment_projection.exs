defmodule Re.Repo.Migrations.CreateTourAppointmentProjection do
  use Ecto.Migration

  def change do
    create table(:tour_appointments_projection, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :wants_tour, :boolean
      add :wants_pictures, :boolean
      add :options, :jsonb, default: "[]"
      add :user_id, references(:users)
      add :listing_id, references(:listings, column: :uuid, type: :uuid)

      timestamps()
    end
  end
end
