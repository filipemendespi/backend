defmodule ReTags.Router do
  use Commanded.Commands.Router

  alias ReTags.Tags.{
    Aggregates.Tag,
    Commands.CreateTag
  }

  middleware ReTags.Middlewares.Validate

  identify Tag, by: :tag_uuid, prefix: "tag-"

  dispatch [CreateTag], to: Tag
end
