defmodule Re.Developments do
  @moduledoc """
  Context for developments.
  """
  @behaviour Bodyguard.Policy

  require Ecto.Query

  alias Re.{
    Development,
    Repo
  }

  alias Ecto.Changeset

  defdelegate authorize(action, user, params), to: __MODULE__.Policy

  def all do
    Re.Development
    |> Re.Repo.all()
  end

  def get(uuid), do: do_get(Development, uuid)

  defp do_get(query, uuid) do
    case Repo.get(query, uuid) do
      nil -> {:error, :not_found}
      development -> {:ok, development}
    end
  end

  def insert(params, address), do: do_insert(params, address)

  defp do_insert(params, address) do
    %Re.Development{}
    |> Changeset.change(address_id: address.id)
    |> Development.changeset(params)
    |> Repo.insert()
  end

  def update(development, params, address) do
    development
    |> Changeset.change(address_id: address.id)
    |> Development.changeset(params)
    |> Repo.update()
  end
end
