defmodule Re.UnitTest do
  use Re.ModelCase

  alias Re.Unit

  import Re.Factory

  @valid_attrs %{
    complement: "100",
    price: 1_000_000,
    property_tax: 500.00,
    maintenance_fee: 300.00,
    floor: "3",
    rooms: 4,
    bathrooms: 4,
    restrooms: 4,
    suites: 1,
    dependencies: 1,
    balconies: 1,
    area: 150,
    garage_spots: 2,
    garage_type: "contract"
  }

  @invalid_attrs %{
    price: -1,
    property_tax: -500.00,
    maintenance_fee: -300.00,
    bathrooms: -1,
    restrooms: -1,
    suites: -1,
    dependencies: -1,
    garage_spots: -1,
    balconies: -1,
    garage_type: "mine"
  }

  describe "changeset/3" do
    test "with valid attributes for development" do
      %{id: listing_id} = insert(:listing)

      attrs =
        @valid_attrs
        |> Map.put(:listing_id, listing_id)

      changeset = Unit.changeset(%Unit{}, attrs, "development")
      assert changeset.valid?
    end

    test "without required attributes for development" do
      changeset = Unit.changeset(%Unit{}, %{}, "development")
      refute changeset.valid?

      assert Keyword.get(changeset.errors, :price) == {"can't be blank", [validation: :required]}

      assert Keyword.get(changeset.errors, :rooms) == {"can't be blank", [validation: :required]}

      assert Keyword.get(changeset.errors, :bathrooms) ==
               {"can't be blank", [validation: :required]}

      assert Keyword.get(changeset.errors, :area) == {"can't be blank", [validation: :required]}

      assert Keyword.get(changeset.errors, :garage_type) ==
               {"can't be blank", [validation: :required]}

      assert Keyword.get(changeset.errors, :suites) == {"can't be blank", [validation: :required]}

      assert Keyword.get(changeset.errors, :dependencies) ==
               {"can't be blank", [validation: :required]}
    end

    test "with invalid attributes for development" do
      changeset = Unit.changeset(%Unit{}, @invalid_attrs, "development")
      refute changeset.valid?

      assert Keyword.get(changeset.errors, :price) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 250_000]}

      assert Keyword.get(changeset.errors, :property_tax) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :maintenance_fee) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :bathrooms) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :garage_spots) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :suites) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :dependencies) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :balconies) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :restrooms) ==
               {"must be greater than or equal to %{number}",
                [validation: :number, kind: :greater_than_or_equal_to, number: 0]}

      assert Keyword.get(changeset.errors, :garage_type) ==
               {"should be one of: [contract condominium]", [validation: :inclusion]}
    end
  end
end
