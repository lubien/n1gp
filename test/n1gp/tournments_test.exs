defmodule N1gp.TournmentsTest do
  use N1gp.DataCase

  alias N1gp.Tournments

  describe "tournments" do
    alias N1gp.Tournments.Tournment

    import N1gp.TournmentsFixtures

    @invalid_attrs %{key: nil, name: nil, type: nil}

    test "list_tournments/0 returns all tournments" do
      tournment = tournment_fixture()
      assert Tournments.list_tournments() == [tournment]
    end

    test "get_tournment!/1 returns the tournment with given id" do
      tournment = tournment_fixture()
      assert Tournments.get_tournment!(tournment.id) == tournment
    end

    test "create_tournment/1 with valid data creates a tournment" do
      valid_attrs = %{key: "some key", name: "some name", type: "some type"}

      assert {:ok, %Tournment{} = tournment} = Tournments.create_tournment(valid_attrs)
      assert tournment.key == "some key"
      assert tournment.name == "some name"
      assert tournment.type == "some type"
    end

    test "create_tournment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournments.create_tournment(@invalid_attrs)
    end

    test "update_tournment/2 with valid data updates the tournment" do
      tournment = tournment_fixture()
      update_attrs = %{key: "some updated key", name: "some updated name", type: "some updated type"}

      assert {:ok, %Tournment{} = tournment} = Tournments.update_tournment(tournment, update_attrs)
      assert tournment.key == "some updated key"
      assert tournment.name == "some updated name"
      assert tournment.type == "some updated type"
    end

    test "update_tournment/2 with invalid data returns error changeset" do
      tournment = tournment_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournments.update_tournment(tournment, @invalid_attrs)
      assert tournment == Tournments.get_tournment!(tournment.id)
    end

    test "delete_tournment/1 deletes the tournment" do
      tournment = tournment_fixture()
      assert {:ok, %Tournment{}} = Tournments.delete_tournment(tournment)
      assert_raise Ecto.NoResultsError, fn -> Tournments.get_tournment!(tournment.id) end
    end

    test "change_tournment/1 returns a tournment changeset" do
      tournment = tournment_fixture()
      assert %Ecto.Changeset{} = Tournments.change_tournment(tournment)
    end
  end
end
