defmodule ReTags.Tags.Aggregates.TagTest do
  use ReTags.AggregateCase, aggregate: ReTags.Tags.Aggregates.Tag

  alias ReTags.Tags.Events.TagCreated

  describe "create tag" do
    test "should succeed when valid" do
      tag_uuid = UUID.uuid4()

      assert_events build(:create_tag, tag_uuid: tag_uuid), [
        %TagCreated{
          tag_uuid: tag_uuid,
          name: "naem",
          visibility: "private"
        }
      ]
    end
  end
end
