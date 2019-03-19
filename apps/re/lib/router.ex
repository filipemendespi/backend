defmodule Re.Router do
  use Commanded.Commands.Router

  alias Re.Calendars.Aggregates.TourAppointment
  alias Re.Calendars.Commands.ScheduleTourAppointment

  dispatch([ScheduleTourAppointment], to: TourAppointment, identity: :lead_id)
end
