defmodule ReTags.Tags.Aggregates.Tag do
  defstruct [
    :uuid,
    :name,
    :visibility
  ]

  alias ReTags.Tags.{
    Commands.CreateTag,
    Events.TagCreated
  }

  def execute(%__MODULE__{}, %CreateTag{} = create) do
    %TagCreated{
      tag_uuid: create.tag_uuid,
      name: create.name,
      visibility: "private"
    }
  end

  def apply(%__MODULE__{} = tag, %TagCreated{} = created) do
    %__MODULE__{
      tag
      | uuid: created.tag_uuid,
        name: created.name,
        visibility: created.visibility
    }
  end
end
