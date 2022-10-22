defmodule N1gp.RoundsTest do
  use N1gp.DataCase

  alias N1gp.Rounds

  describe "rounds" do
    alias N1gp.Rounds.Round

    import N1gp.RoundsFixtures

    @invalid_attrs %{challonge_id: nil, completed_at: nil, name: nil, position: nil, started_at: nil, type: nil}

    test "list_rounds/0 returns all rounds" do
      round = round_fixture()
      assert Rounds.list_rounds() == [round]
    end

    test "get_round!/1 returns the round with given id" do
      round = round_fixture()
      assert Rounds.get_round!(round.id) == round
    end

    test "create_round/1 with valid data creates a round" do
      valid_attrs = %{challonge_id: 42, completed_at: ~N[2022-10-21 20:47:00.000000], name: "some name", position: 42, started_at: ~N[2022-10-21 20:47:00.000000], type: "some type"}

      assert {:ok, %Round{} = round} = Rounds.create_round(valid_attrs)
      assert round.challonge_id == 42
      assert round.completed_at == ~N[2022-10-21 20:47:00.000000]
      assert round.name == "some name"
      assert round.position == 42
      assert round.started_at == ~N[2022-10-21 20:47:00.000000]
      assert round.type == "some type"
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rounds.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      round = round_fixture()
      update_attrs = %{challonge_id: 43, completed_at: ~N[2022-10-22 20:47:00.000000], name: "some updated name", position: 43, started_at: ~N[2022-10-22 20:47:00.000000], type: "some updated type"}

      assert {:ok, %Round{} = round} = Rounds.update_round(round, update_attrs)
      assert round.challonge_id == 43
      assert round.completed_at == ~N[2022-10-22 20:47:00.000000]
      assert round.name == "some updated name"
      assert round.position == 43
      assert round.started_at == ~N[2022-10-22 20:47:00.000000]
      assert round.type == "some updated type"
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = round_fixture()
      assert {:error, %Ecto.Changeset{}} = Rounds.update_round(round, @invalid_attrs)
      assert round == Rounds.get_round!(round.id)
    end

    test "delete_round/1 deletes the round" do
      round = round_fixture()
      assert {:ok, %Round{}} = Rounds.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Rounds.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = round_fixture()
      assert %Ecto.Changeset{} = Rounds.change_round(round)
    end
  end
end
