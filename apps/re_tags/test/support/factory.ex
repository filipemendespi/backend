defmodule ReTags.Factory do
  use ExMachina

  alias ReTags.Tags.Commands.CreateTag

  def tag_factory do
    %{
      tag_uuid: UUID.uuid4(),
      name: "naem",
      visibility: "body"
    }
  end

  def create_tag_factory do
    struct(CreateTag, build(:tag))
  end
end
