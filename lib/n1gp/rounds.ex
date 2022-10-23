defmodule N1gp.Rounds do
  @moduledoc """
  The Rounds context.
  """

  import Ecto.Query, warn: false
  alias N1gp.Repo

  alias N1gp.Rounds.Round

  @doc """
  Returns the list of rounds.

  ## Examples

      iex> list_rounds()
      [%Round{}, ...]

  """
  def list_rounds do
    Repo.all(Round)
  end

  @doc """
  Gets a single round.

  Raises `Ecto.NoResultsError` if the Round does not exist.

  ## Examples

      iex> get_round!(123)
      %Round{}

      iex> get_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_round!(id), do: Repo.get!(Round, id)

  @doc """
  Creates a round.

  ## Examples

      iex> create_round(%{field: value})
      {:ok, %Round{}}

      iex> create_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a round.

  ## Examples

      iex> update_round(round, %{field: new_value})
      {:ok, %Round{}}

      iex> update_round(round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a round.

  ## Examples

      iex> delete_round(round)
      {:ok, %Round{}}

      iex> delete_round(round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round changes.

  ## Examples

      iex> change_round(round)
      %Ecto.Changeset{data: %Round{}}

  """
  def change_round(%Round{} = round, attrs \\ %{}) do
    Round.changeset(round, attrs)
  end

  alias N1gp.Rounds.RoundParticipant

  @doc """
  Returns the list of rounds_participants.

  ## Examples

      iex> list_rounds_participants()
      [%RoundParticipant{}, ...]

  """
  def list_rounds_participants do
    Repo.all(RoundParticipant)
  end

  @doc """
  Gets a single round_participant.

  Raises `Ecto.NoResultsError` if the Round participant does not exist.

  ## Examples

      iex> get_round_participant!(123)
      %RoundParticipant{}

      iex> get_round_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_round_participant!(id), do: Repo.get!(RoundParticipant, id)

  @doc """
  Creates a round_participant.

  ## Examples

      iex> create_round_participant(%{field: value})
      {:ok, %RoundParticipant{}}

      iex> create_round_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_round_participant(attrs \\ %{}) do
    %RoundParticipant{}
    |> RoundParticipant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a round_participant.

  ## Examples

      iex> update_round_participant(round_participant, %{field: new_value})
      {:ok, %RoundParticipant{}}

      iex> update_round_participant(round_participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_round_participant(%RoundParticipant{} = round_participant, attrs) do
    round_participant
    |> RoundParticipant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a round_participant.

  ## Examples

      iex> delete_round_participant(round_participant)
      {:ok, %RoundParticipant{}}

      iex> delete_round_participant(round_participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_round_participant(%RoundParticipant{} = round_participant) do
    Repo.delete(round_participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round_participant changes.

  ## Examples

      iex> change_round_participant(round_participant)
      %Ecto.Changeset{data: %RoundParticipant{}}

  """
  def change_round_participant(%RoundParticipant{} = round_participant, attrs \\ %{}) do
    RoundParticipant.changeset(round_participant, attrs)
  end

  alias N1gp.Rounds.Match

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end
end
