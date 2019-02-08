defmodule ReTags.Tags.Commands.CreateTag do
  defstruct [
    :tag_uuid,
    :name
  ]

  use ExConstructor
  use Vex.Struct

  alias ReTags.Tags.Validators.UniqueName

  validates :tag_uuid, uuid: true

  validates :name,
    presence: [message: "can't be empty"],
    string: true,
    by: &UniqueName.validate/2

  def assign_uuid(%__MODULE__{} = create_tag, uuid) do
    %__MODULE__{create_tag | tag_uuid: uuid}
  end
end
