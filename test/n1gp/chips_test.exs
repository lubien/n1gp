defmodule N1gp.ChipsTest do
  use N1gp.DataCase

  alias N1gp.Chips

  describe "chips" do
    alias N1gp.Chips.Chip

    import N1gp.ChipsFixtures

    @invalid_attrs %{aliases: nil, atk: nil, codes: nil, description: nil, elements: nil, image: nil, mb: nil, more_details: nil, name: nil}

    test "list_chips/0 returns all chips" do
      chip = chip_fixture()
      assert Chips.list_chips() == [chip]
    end

    test "get_chip!/1 returns the chip with given id" do
      chip = chip_fixture()
      assert Chips.get_chip!(chip.id) == chip
    end

    test "create_chip/1 with valid data creates a chip" do
      valid_attrs = %{aliases: [], atk: 42, codes: [], description: "some description", elements: [], image: "some image", mb: 42, more_details: [], name: "some name"}

      assert {:ok, %Chip{} = chip} = Chips.create_chip(valid_attrs)
      assert chip.aliases == []
      assert chip.atk == 42
      assert chip.codes == []
      assert chip.description == "some description"
      assert chip.elements == []
      assert chip.image == "some image"
      assert chip.mb == 42
      assert chip.more_details == []
      assert chip.name == "some name"
    end

    test "create_chip/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chips.create_chip(@invalid_attrs)
    end

    test "update_chip/2 with valid data updates the chip" do
      chip = chip_fixture()
      update_attrs = %{aliases: [], atk: 43, codes: [], description: "some updated description", elements: [], image: "some updated image", mb: 43, more_details: [], name: "some updated name"}

      assert {:ok, %Chip{} = chip} = Chips.update_chip(chip, update_attrs)
      assert chip.aliases == []
      assert chip.atk == 43
      assert chip.codes == []
      assert chip.description == "some updated description"
      assert chip.elements == []
      assert chip.image == "some updated image"
      assert chip.mb == 43
      assert chip.more_details == []
      assert chip.name == "some updated name"
    end

    test "update_chip/2 with invalid data returns error changeset" do
      chip = chip_fixture()
      assert {:error, %Ecto.Changeset{}} = Chips.update_chip(chip, @invalid_attrs)
      assert chip == Chips.get_chip!(chip.id)
    end

    test "delete_chip/1 deletes the chip" do
      chip = chip_fixture()
      assert {:ok, %Chip{}} = Chips.delete_chip(chip)
      assert_raise Ecto.NoResultsError, fn -> Chips.get_chip!(chip.id) end
    end

    test "change_chip/1 returns a chip changeset" do
      chip = chip_fixture()
      assert %Ecto.Changeset{} = Chips.change_chip(chip)
    end
  end
end
