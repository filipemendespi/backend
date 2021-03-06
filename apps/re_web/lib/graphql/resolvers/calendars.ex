defmodule ReWeb.Resolvers.Calendars do
  @moduledoc """
  Resolver module for calendars
  """
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  alias Re.{
    Calendars,
    Listings
  }

  def tour_options(_, %{context: %{current_user: current_user}}) do
    with :ok <- Bodyguard.permit(Calendars, :tour_options, current_user, %{}),
         do: {:ok, Calendars.generate_tour_options(Timex.now(), 5)}
  end

  def schedule_tour(%{input: %{listing_id: listing_id} = params}, %{
        context: %{current_user: current_user}
      }) do
    with :ok <- Bodyguard.permit(Calendars, :schedule_tour, current_user, %{}),
         {:ok, listing} <- Listings.get(listing_id),
         params <- Map.put(params, :user_id, current_user.id) do
      Calendars.schedule_tour(params, listing)
    end
  end

  def listings(tour_appointment, _, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Listings, {:listing, %{has_admin_rights: true}}, tour_appointment)
    |> on_load(fn loader ->
      {:ok,
       Dataloader.get(loader, Listings, {:listing, %{has_admin_rights: true}}, tour_appointment)}
    end)
  end
end
