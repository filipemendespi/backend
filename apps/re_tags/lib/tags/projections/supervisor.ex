defmodule ReTags.Tags.Projections.Supervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  def init(_arg) do
    Supervisor.init(
      [
        ReTags.Tags.Projectors.Tag
      ],
      strategy: :one_for_one
    )
  end
end
