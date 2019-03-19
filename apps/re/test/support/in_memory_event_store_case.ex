defmodule InMemoryEventStoreCase do
  use ExUnit.CaseTemplate

  alias Commanded.EventStore.Adapters.InMemory

  setup tags do
    on_exit(fn ->
      :ok = Application.stop(:re)

      InMemory.reset!()

      {:ok, _apps} = Application.ensure_all_started(:re)

      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Re.Repo)

      unless tags[:async] do
        Ecto.Adapters.SQL.Sandbox.mode(Re.Repo, {:shared, self()})
      end

      :ok
    end)
  end
end
