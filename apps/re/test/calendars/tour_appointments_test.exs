defmodule Re.Calendars.TourAppointmentsTest do
  use InMemoryEventStoreCase

  import Commanded.Assertions.EventAssertions
  import Re.EventStoreFactory

  alias Re.{
    Calendars.TourAppointments,
    Calendars.Events.TourAppointmentScheduled,
    Calendars.Projections.TourAppointment
  }

  test "a tour appointment should be scheduled" do
    {:ok, tour_appointment} =
      TourAppointments.schedule_tour(build(:tour_appointment), %{uuid: UUID.uuid4()}, %{id: 1})

    assert_receive_event(TourAppointmentScheduled, fn tour_appointment ->
      assert tour_appointment.lead_id == ""
      assert tour_appointment.wants_tour
      assert tour_appointment.wants_pictures
      assert tour_appointment.options == []
    end)

    assert Repo.get(TourAppointment, tour_appointment.uuid)
  end
end
