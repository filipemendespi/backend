defmodule Re.Calendars.Commands.ScheduleTourAppointment do
  defstruct [
    :lead_id,
    :wants_tour,
    :wants_pictures,
    :options,
    :user_id,
    :listing_id
  ]

  alias Ecto.Changeset

  def new(%{valid?: false} = changeset), do: {:error, changeset}

  def new(changeset) do
    %__MODULE__{
      lead_id: Changeset.get_field(changeset, :lead_id),
      wants_tour: Changeset.get_field(changeset, :wants_tour),
      wants_pictures: Changeset.get_field(changeset, :wants_pictures),
      options: Changeset.get_field(changeset, :options),
      user_id: Changeset.get_field(changeset, :user_id),
      listing_id: Changeset.get_field(changeset, :listing_id)
    }
  end
end
