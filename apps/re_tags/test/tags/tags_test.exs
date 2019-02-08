defmodule ReTags.Tags.TagTest do
  use ReTags.DataCase

  import Commanded.Assertions.EventAssertions
  import ReTags.Factory

  alias ReTags.{
    Tags,
    Tags.Events.TagCreated,
    Tags.Projections.Tag
  }

  describe "a tag" do
    test "should be created" do
      {:ok, tag} = Tags.create(build(:tag))

      assert_receive_event TagCreated, fn tag ->
        assert tag.name == "naem"
        assert tag.visibility == "private"
      end

      assert Repo.get(Tag, tag.uuid)
    end

    test "should not be created twice with same name" do
      Tags.create(build(:tag))
      Tags.create(build(:tag))

      assert [_tag] = Repo.all(Tag)
    end
  end
end
