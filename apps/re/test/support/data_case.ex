defmodule Re.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Re.Factory
      import Re.DataCase
      import Commanded.Assertions.EventAssertions
    end
  end

  setup do
    on_exit(fn ->
      :ok = Application.stop(:re)
      :ok = Application.stop(:commanded)
      :ok = Application.stop(:eventstore)

      reset_readstore()

      {:ok, _} = Application.ensure_all_started(:re)
    end)

    :ok
  end

  def reset_readstore do
    {:ok, conn} =
      :eventstore
      |> Application.get_env(EventStore.Storage)
      |> Postgrex.start_link()

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
      tour_appointments_projection,
      projection_versions
    RESTART IDENTITY
    CASCADE;
    """
  end
end
