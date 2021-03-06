defmodule Re.Application do
  @moduledoc """
  Application module for Re, starts supervision tree.
  """

  use Application

  import Supervisor.Spec

  alias Re.{
    Listings.History.Server,
    Statistics.Visualizations
  }

  def start(_type, _args) do
    attach_telemetry()

    children =
      [
        supervisor(Re.Repo, []),
        supervisor(Phoenix.PubSub.PG2, [Re.PubSub, []])
      ] ++ extra_processes(Mix.env())

    opts = [strategy: :one_for_one, name: Re.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp extra_processes(:test), do: []

  defp extra_processes(_),
    do: [
      worker(Server, []),
      worker(Visualizations, [])
    ]

  defp attach_telemetry do
    :ok =
      :telemetry.attach(
        "timber-ecto-query-handler",
        [:re, :repo, :query],
        &Timber.Ecto.handle_event/4,
        []
      )
  end
end
