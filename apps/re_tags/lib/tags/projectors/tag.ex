defmodule ReTags.Tags.Projectors.Tag do
  use Commanded.Projections.Ecto,
    name: "Tags.Projectors.Tag",
    consistency: :strong

  alias ReTags.Tags.{
    Projections.Tag,
    Events.TagCreated
  }

  project %TagCreated{} = tag_created do
    Ecto.Multi.insert(
      multi,
      :tag_projections,
      %Tag{
        uuid: tag_created.tag_uuid,
        name: tag_created.name,
        visibility: tag_created.visibility
      }
    )
  end
end
