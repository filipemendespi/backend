defmodule ReWeb.Resolvers.Units do
  @moduledoc """
  Resolver module for units
  """
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  alias Re.{
    Unit,
    Units
  }

  def per_listing(listing, _params, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Units, {:many, Unit}, listing_uuid: listing.uuid)
    |> on_load(fn loader ->
      {:ok, Dataloader.get(loader, Units, {:many, Unit}, listing_uuid: listing.uuid)}
    end)
  end
end
