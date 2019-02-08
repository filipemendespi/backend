defmodule ReTags.Tags do
  @moduledoc """
  Context module for tags
  """

  alias ReTags.{
    Repo,
    Router,
    Tags.Commands.CreateTag,
    Tags.Projections.Tag
  }

  def by_name(name), do: get_by(Tag, name: name)

  def create(params) do
    uuid = UUID.uuid4()

    params
    |> CreateTag.new()
    |> CreateTag.assign_uuid(uuid)
    |> Router.dispatch(consistency: :strong)
    |> case do
      :ok -> get(Tag, uuid)
      error -> error
    end
  end

  defp get_by(schema, kv) do
    case Repo.get_by(schema, kv) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp get(schema, id) do
    case Repo.get(schema, id) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
