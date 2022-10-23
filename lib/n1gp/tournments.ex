defmodule N1gp.Tournments do
  @moduledoc """
  The Tournments context.
  """

  import Ecto.Query, warn: false
  alias N1gp.Repo

  alias N1gp.Chips
  alias N1gp.Tournments.Tournment
  alias N1gp.Tournments.Participant
  alias N1gp.Tournments.ParticipantChip
  alias N1gp.Rounds.Round
  alias N1gp.Rounds.RoundParticipant
  alias N1gp.Rounds.Match

  def import_tournment(attrs) do
    Repo.transaction(fn ->
      tournment_attrs =
        attrs
        |> N1gp.Importer.import_tournment()

      {:ok, tournment} =
        tournment_attrs
        |> create_tournment(conflict_target: :key, on_conflict: {:replace, [:name, :type]})

      timestamp =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)

      placeholders = %{timestamp: timestamp}

      participant_changesets =
        tournment_attrs.participants
        |> Enum.map(fn participant ->
          participant
          |> Map.delete(:folder)
          |> Map.merge(%{
            inserted_at: {:placeholder, :timestamp},
            updated_at: {:placeholder, :timestamp},
            tournment_id: tournment.id
          })
        end)

      fields = [
        :discord_name,
        :name,
        :navicust,
        :navicust_image,
        :version,
      ]

      {_count, participants} =
        Repo.insert_all(Participant, participant_changesets,
        returning: true,
        placeholders: placeholders,
        conflict_target: [:tournment_id, :entrant_no],
        on_conflict: {:replace, fields}
      )

      chip_id_by_name =

        Chips.list_chips()
        |> Enum.flat_map(fn chip ->
          [{chip.name, chip.id}] ++ Enum.map(chip.aliases, fn a ->{a, chip.id} end)
        end)
        |> Enum.into(%{})

      fields = [
        :code,
        :quantity,
        :reg_or_tag,
      ]

      participants_chips =
        tournment_attrs.participants
        |> Enum.flat_map(fn participant ->
          participant.folder
          |> Enum.map(fn chip ->
            participant = Enum.find(participants, & &1.entrant_no == participant.entrant_no)

            chip
            |> Map.delete(:name)
            |> Map.merge(%{
              inserted_at: {:placeholder, :timestamp},
              updated_at: {:placeholder, :timestamp},
              chip_id: chip_id_by_name[chip.name],
              participant_id: participant.id,
            })
          end)
        end)
        # TODO: find out which are duplicated
        |> Enum.uniq_by(&"#{&1.chip_id}:#{&1.participant_id}")


      {_count, participants_chips} =
        Repo.insert_all(ParticipantChip, participants_chips,
          returning: true,
          placeholders: placeholders,
          conflict_target: [:chip_id, :participant_id],
          on_conflict: {:replace, fields}
        )

      fields = [
        :position,
        :name,
        :type,
        :started_at,
        :completed_at,
      ]

      rounds =
        tournment_attrs.rounds
        |> Enum.map(fn round ->
          round
          |> Map.drop([:participants, :matches])
          |> Map.merge(%{
            inserted_at: {:placeholder, :timestamp},
            updated_at: {:placeholder, :timestamp},
            tournment_id: tournment.id
          })
        end)

      {_count, rounds} =
        Repo.insert_all(Round, rounds,
          returning: true,
          placeholders: placeholders,
          conflict_target: :challonge_id,
          on_conflict: {:replace, fields}
        )

      fields = [
        :challonge_id,
        :round_id,
        :participant_id,
      ]

      round_participants =
        tournment_attrs.rounds
        |> Enum.flat_map(fn round ->
          round_on_db = Enum.find(rounds, & &1.position == round.position)

          round.participants
          |> Enum.map(fn participant ->
            participant_on_db = Enum.find(participants, & &1.entrant_no == participant.entrant_no)

            %{
              challonge_id: participant.challonge_id,
              participant_id: participant_on_db.id,
              round_id: round_on_db.id,
              inserted_at: {:placeholder, :timestamp},
              updated_at: {:placeholder, :timestamp},
            }
          end)
        end)

      {_count, round_participants} =
        Repo.insert_all(RoundParticipant, round_participants,
        returning: true,
        placeholders: placeholders,
        conflict_target: [:participant_id, :round_id],
        on_conflict: {:replace, fields}
      )

      fields = [
        :completed_at,
        :scores_csv,
        :started_at,
        :state,
        :round_id,
        :participant1_id,
        :participant2_id,
        :winner_id,
        :forfeited,
        :challonge_round,
      ]

      matches =
        tournment_attrs.rounds
        |> Enum.flat_map(fn round ->
          round_on_db = Enum.find(rounds, & &1.position == round.position)

          round.matches
          # |> Enum.take(1)
          |> Enum.map(fn match ->
            participant1_on_db = Enum.find(participants, & &1.entrant_no == match.participant1_id)
            participant2_on_db = Enum.find(participants, & &1.entrant_no == match.participant2_id)
            winner_on_db = Enum.find(participants, & &1.entrant_no == match.winner_id)

            %{
              challonge_id: match.challonge_id,
              state: match.state,
              started_at: match.started_at,
              completed_at: match.completed_at,
              scores_csv: match.scores_csv,
              challonge_round: match.challonge_round,
              forfeited: match.forfeited,

              participant1_id: Map.get(participant1_on_db || %{}, :id),
              participant2_id: Map.get(participant2_on_db || %{}, :id),
              winner_id: Map.get(winner_on_db || %{}, :id),
              round_id: round_on_db.id,

              inserted_at: {:placeholder, :timestamp},
              updated_at: {:placeholder, :timestamp},
            }
          end)
        end)

      # matches |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

      {_count, matches} =
        Repo.insert_all(Match, matches,
        returning: true,
        placeholders: placeholders,
        conflict_target: :challonge_id,
        on_conflict: {:replace, fields}
      )
      # |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
    end)
  end

  @doc """
  Returns the list of tournments.

  ## Examples

      iex> list_tournments()
      [%Tournment{}, ...]

  """
  def list_tournments do
    Repo.all(Tournment)
  end

  @doc """
  Gets a single tournment.

  Raises `Ecto.NoResultsError` if the Tournment does not exist.

  ## Examples

      iex> get_tournment!(123)
      %Tournment{}

      iex> get_tournment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournment!(id) do
    Tournment
    # |> preload([:participants])
    |> preload([:participants, :matches, rounds: [:round_participants]])
    |> Repo.get!(id)
    # |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
  end

  def calculate_matches_breakdown(matches) do

    matches
    |> Enum.reduce(%{}, fn %{participant1_id: participant1_id, participant2_id: participant2_id} = match, acc ->
      # if match.winner_id == 989 do
      #   match |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
      # end
      bucket_1 = Map.get(acc, participant1_id, match_breakdown_bucket())
      bucket_2 = Map.get(acc, participant2_id, match_breakdown_bucket())

      # {participant1_id, participant2_id, match.winner_id} |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
      {bucket_1, bucket_2} =
        case match.winner_id do
          ^participant1_id ->
            {
              Map.update(bucket_1, :won, 1, & &1 + 1),
              add_loss_to_match_breakdown(match, bucket_2)
            }
          ^participant2_id ->
            {
              add_loss_to_match_breakdown(match, bucket_1),
              Map.update(bucket_2, :won, 1, & &1 + 1)
            }

          _ ->
            {bucket_1, bucket_2}
        end

      acc
      |> Map.put(participant1_id, bucket_1)
      |> Map.put(participant2_id, bucket_2)
      # |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
    end)
  end

  defp match_breakdown_bucket do
    %{ won: 0, lost: 0, forfeited: 0}
  end

  defp add_loss_to_match_breakdown(match, bucket) do
    bucket
    |> Map.update(:forfeited, 1, fn val ->
      if match.forfeited do
        val + 1
      else
        val
      end
    end)
    |> Map.update(:lost, 1, & &1 + 1)
  end

  @doc """
  Creates a tournment.

  ## Examples

      iex> create_tournment(%{field: value})
      {:ok, %Tournment{}}

      iex> create_tournment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournment(attrs \\ %{}, opts \\ []) do
    %Tournment{}
    |> Tournment.changeset(attrs)
    |> Repo.insert(opts)
  end

  @doc """
  Updates a tournment.

  ## Examples

      iex> update_tournment(tournment, %{field: new_value})
      {:ok, %Tournment{}}

      iex> update_tournment(tournment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournment(%Tournment{} = tournment, attrs) do
    tournment
    |> Tournment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournment.

  ## Examples

      iex> delete_tournment(tournment)
      {:ok, %Tournment{}}

      iex> delete_tournment(tournment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournment(%Tournment{} = tournment) do
    Repo.delete(tournment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournment changes.

  ## Examples

      iex> change_tournment(tournment)
      %Ecto.Changeset{data: %Tournment{}}

  """
  def change_tournment(%Tournment{} = tournment, attrs \\ %{}) do
    Tournment.changeset(tournment, attrs)
  end

  @doc """
  Returns the list of participants.

  ## Examples

      iex> list_participants()
      [%Participant{}, ...]

  """
  def list_participants do
    Repo.all(Participant)
  end

  @doc """
  Gets a single participant.

  Raises `Ecto.NoResultsError` if the Participant does not exist.

  ## Examples

      iex> get_participant!(123)
      %Participant{}

      iex> get_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participant!(id), do: Repo.get!(Participant, id)

  @doc """
  Creates a participant.

  ## Examples

      iex> create_participant(%{field: value})
      {:ok, %Participant{}}

      iex> create_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a participant.

  ## Examples

      iex> update_participant(participant, %{field: new_value})
      {:ok, %Participant{}}

      iex> update_participant(participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a participant.

  ## Examples

      iex> delete_participant(participant)
      {:ok, %Participant{}}

      iex> delete_participant(participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participant changes.

  ## Examples

      iex> change_participant(participant)
      %Ecto.Changeset{data: %Participant{}}

  """
  def change_participant(%Participant{} = participant, attrs \\ %{}) do
    Participant.changeset(participant, attrs)
  end
end
