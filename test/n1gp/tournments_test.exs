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

  describe "participants" do
    alias N1gp.Tournments.Participant

    import N1gp.TournmentsFixtures

    @invalid_attrs %{discord_name: nil, entrant_no: nil, name: nil, navicust: nil, navicust_image: nil, version: nil}

    test "list_participants/0 returns all participants" do
      participant = participant_fixture()
      assert Tournments.list_participants() == [participant]
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = participant_fixture()
      assert Tournments.get_participant!(participant.id) == participant
    end

    test "create_participant/1 with valid data creates a participant" do
      valid_attrs = %{discord_name: "some discord_name", entrant_no: 42, name: "some name", navicust: [], navicust_image: "some navicust_image", version: "some version"}

      assert {:ok, %Participant{} = participant} = Tournments.create_participant(valid_attrs)
      assert participant.discord_name == "some discord_name"
      assert participant.entrant_no == 42
      assert participant.name == "some name"
      assert participant.navicust == []
      assert participant.navicust_image == "some navicust_image"
      assert participant.version == "some version"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournments.create_participant(@invalid_attrs)
    end

    test "update_participant/2 with valid data updates the participant" do
      participant = participant_fixture()
      update_attrs = %{discord_name: "some updated discord_name", entrant_no: 43, name: "some updated name", navicust: [], navicust_image: "some updated navicust_image", version: "some updated version"}

      assert {:ok, %Participant{} = participant} = Tournments.update_participant(participant, update_attrs)
      assert participant.discord_name == "some updated discord_name"
      assert participant.entrant_no == 43
      assert participant.name == "some updated name"
      assert participant.navicust == []
      assert participant.navicust_image == "some updated navicust_image"
      assert participant.version == "some updated version"
    end

    test "update_participant/2 with invalid data returns error changeset" do
      participant = participant_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournments.update_participant(participant, @invalid_attrs)
      assert participant == Tournments.get_participant!(participant.id)
    end

    test "delete_participant/1 deletes the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{}} = Tournments.delete_participant(participant)
      assert_raise Ecto.NoResultsError, fn -> Tournments.get_participant!(participant.id) end
    end

    test "change_participant/1 returns a participant changeset" do
      participant = participant_fixture()
      assert %Ecto.Changeset{} = Tournments.change_participant(participant)
    end
  end
end
