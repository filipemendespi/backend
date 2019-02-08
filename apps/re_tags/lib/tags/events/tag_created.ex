defmodule ReTags.Tags.Events.TagCreated do
  defstruct [
    :tag_uuid,
    :name,
    visibility: "private"
  ]
end
