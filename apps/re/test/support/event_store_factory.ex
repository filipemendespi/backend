defmodule Re.EventStoreFactory do
  use ExMachina

  def tour_appointment_factory do
    %{
      lead_id: UUID.uuid4(),
      wants_pictures: true,
      wants_tour: true,
      options: []
    }
  end
end
