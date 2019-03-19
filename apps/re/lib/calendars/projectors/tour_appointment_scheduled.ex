defmodule Re.Calendars.Projectors.TourAppointmentScheduled do
  use Commanded.Projections.Ecto,
    name: "Calendars.Projectors.TourAppointmentScheduled"

  alias Re.Calendars.Events.TourAppointmentScheduled
  alias Re.Calendars.Projections.TourAppointment

  project %TourAppointmentScheduled{} = tas do
    Ecto.Multi.insert(
      multi,
      :tour_appointment_scheduled,
      %TourAppointment{
        uuid: tas.lead_id,
        wants_tour: tas.wants_tour,
        wants_pictures: tas.wants_pictures,
        options: tas.options,
        user_id: tas.user_id,
        listing_uuid: tas.listing_id
      }
    )
  end
end
