defmodule ReTags.Storage do
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    :ok = Application.stop(:re_tags)
    :ok = Application.stop(:commanded)
    :ok = Application.stop(:eventstore)

    reset_eventstore()
    reset_readstore()

    {:ok, _} = Application.ensure_all_started(:re_tags)
  end

  defp reset_eventstore do
    {:ok, conn} =
      EventStore.configuration()
      |> EventStore.Config.parse()
      |> EventStore.Config.default_postgrex_opts()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn)
  end

  defp reset_readstore do
    readstore_config = Application.get_env(:re_tags, ReTags.Repo)

    {:ok, conn} = Postgrex.start_link(readstore_config)

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
      tag_projections,
      projection_versions
    RESTART IDENTITY;
    """
  end
end
