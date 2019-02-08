defmodule ReTags.Tags.Projections.Tag do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "tag_projections" do
    field :name, :string
    field :visibility, :string

    timestamps()
  end
end
