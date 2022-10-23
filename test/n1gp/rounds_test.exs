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

  describe "rounds_participants" do
    alias N1gp.Rounds.RoundParticipant

    import N1gp.RoundsFixtures

    @invalid_attrs %{challonge_id: nil}

    test "list_rounds_participants/0 returns all rounds_participants" do
      round_participant = round_participant_fixture()
      assert Rounds.list_rounds_participants() == [round_participant]
    end

    test "get_round_participant!/1 returns the round_participant with given id" do
      round_participant = round_participant_fixture()
      assert Rounds.get_round_participant!(round_participant.id) == round_participant
    end

    test "create_round_participant/1 with valid data creates a round_participant" do
      valid_attrs = %{challonge_id: 42}

      assert {:ok, %RoundParticipant{} = round_participant} = Rounds.create_round_participant(valid_attrs)
      assert round_participant.challonge_id == 42
    end

    test "create_round_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rounds.create_round_participant(@invalid_attrs)
    end

    test "update_round_participant/2 with valid data updates the round_participant" do
      round_participant = round_participant_fixture()
      update_attrs = %{challonge_id: 43}

      assert {:ok, %RoundParticipant{} = round_participant} = Rounds.update_round_participant(round_participant, update_attrs)
      assert round_participant.challonge_id == 43
    end

    test "update_round_participant/2 with invalid data returns error changeset" do
      round_participant = round_participant_fixture()
      assert {:error, %Ecto.Changeset{}} = Rounds.update_round_participant(round_participant, @invalid_attrs)
      assert round_participant == Rounds.get_round_participant!(round_participant.id)
    end

    test "delete_round_participant/1 deletes the round_participant" do
      round_participant = round_participant_fixture()
      assert {:ok, %RoundParticipant{}} = Rounds.delete_round_participant(round_participant)
      assert_raise Ecto.NoResultsError, fn -> Rounds.get_round_participant!(round_participant.id) end
    end

    test "change_round_participant/1 returns a round_participant changeset" do
      round_participant = round_participant_fixture()
      assert %Ecto.Changeset{} = Rounds.change_round_participant(round_participant)
    end
  end

  describe "matches" do
    alias N1gp.Rounds.Match

    import N1gp.RoundsFixtures

    @invalid_attrs %{challonge_id: nil, completed_at: nil, scores_csv: nil, started_at: nil, state: nil}

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Rounds.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Rounds.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{challonge_id: 42, completed_at: ~U[2022-10-22 10:16:00.000000Z], scores_csv: "some scores_csv", started_at: ~U[2022-10-22 10:16:00.000000Z], state: "some state"}

      assert {:ok, %Match{} = match} = Rounds.create_match(valid_attrs)
      assert match.challonge_id == 42
      assert match.completed_at == ~U[2022-10-22 10:16:00.000000Z]
      assert match.scores_csv == "some scores_csv"
      assert match.started_at == ~U[2022-10-22 10:16:00.000000Z]
      assert match.state == "some state"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rounds.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      update_attrs = %{challonge_id: 43, completed_at: ~U[2022-10-23 10:16:00.000000Z], scores_csv: "some updated scores_csv", started_at: ~U[2022-10-23 10:16:00.000000Z], state: "some updated state"}

      assert {:ok, %Match{} = match} = Rounds.update_match(match, update_attrs)
      assert match.challonge_id == 43
      assert match.completed_at == ~U[2022-10-23 10:16:00.000000Z]
      assert match.scores_csv == "some updated scores_csv"
      assert match.started_at == ~U[2022-10-23 10:16:00.000000Z]
      assert match.state == "some updated state"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Rounds.update_match(match, @invalid_attrs)
      assert match == Rounds.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Rounds.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Rounds.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Rounds.change_match(match)
    end
  end
end
