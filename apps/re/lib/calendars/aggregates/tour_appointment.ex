defmodule Re.Calendars.Aggregates.TourAppointment do
  defstruct uuid: nil

  alias __MODULE__
  alias Re.Calendars.Commands.ScheduleTourAppointment
  alias Re.Calendars.Events.TourAppointmentScheduled

  def execute(_, %ScheduleTourAppointment{} = sta) do
    %TourAppointmentScheduled{
      lead_id: sta.lead_id,
      wants_tour: sta.wants_tour,
      wants_pictures: sta.wants_pictures,
      options: sta.options,
      user_id: sta.user_id,
      listing_id: sta.listing_id
    }
  end

  def apply(%TourAppointment{} = ta, %TourAppointmentScheduled{} = sta) do
    %TourAppointment{ta | uuid: sta.lead_id}
  end
end
