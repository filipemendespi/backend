defmodule Re.Listings.Schemas.Tag do
  @moduledoc """
  Model for listings's tags
  """
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :name, :string

    timestamps()
  end

  @attributes ~w(name)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @attributes)
    |> validate_required(@attributes)
  end
end
