defmodule N1gp.RoundsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `N1gp.Rounds` context.
  """

  @doc """
  Generate a unique round challonge_id.
  """
  def unique_round_challonge_id, do: System.unique_integer([:positive])

  @doc """
  Generate a round.
  """
  def round_fixture(attrs \\ %{}) do
    {:ok, round} =
      attrs
      |> Enum.into(%{
        challonge_id: unique_round_challonge_id(),
        completed_at: ~N[2022-10-21 20:47:00.000000],
        name: "some name",
        position: 42,
        started_at: ~N[2022-10-21 20:47:00.000000],
        type: "some type"
      })
      |> N1gp.Rounds.create_round()

    round
  end

  @doc """
  Generate a unique round_participant challonge_id.
  """
  def unique_round_participant_challonge_id, do: System.unique_integer([:positive])

  @doc """
  Generate a round_participant.
  """
  def round_participant_fixture(attrs \\ %{}) do
    {:ok, round_participant} =
      attrs
      |> Enum.into(%{
        challonge_id: unique_round_participant_challonge_id()
      })
      |> N1gp.Rounds.create_round_participant()

    round_participant
  end

  @doc """
  Generate a unique match challonge_id.
  """
  def unique_match_challonge_id, do: System.unique_integer([:positive])

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        challonge_id: unique_match_challonge_id(),
        completed_at: ~U[2022-10-22 10:16:00.000000Z],
        scores_csv: "some scores_csv",
        started_at: ~U[2022-10-22 10:16:00.000000Z],
        state: "some state"
      })
      |> N1gp.Rounds.create_match()

    match
  end
end
