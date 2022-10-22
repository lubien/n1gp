defmodule N1gp.TournmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `N1gp.Tournments` context.
  """

  @doc """
  Generate a unique tournment key.
  """
  def unique_tournment_key, do: "some key#{System.unique_integer([:positive])}"

  @doc """
  Generate a tournment.
  """
  def tournment_fixture(attrs \\ %{}) do
    {:ok, tournment} =
      attrs
      |> Enum.into(%{
        key: unique_tournment_key(),
        name: "some name",
        type: "some type"
      })
      |> N1gp.Tournments.create_tournment()

    tournment
  end

  @doc """
  Generate a participant.
  """
  def participant_fixture(attrs \\ %{}) do
    {:ok, participant} =
      attrs
      |> Enum.into(%{
        discord_name: "some discord_name",
        entrant_no: 42,
        name: "some name",
        navicust: [],
        navicust_image: "some navicust_image",
        version: "some version"
      })
      |> N1gp.Tournments.create_participant()

    participant
  end

  @doc """
  Generate a participant_chip.
  """
  def participant_chip_fixture(attrs \\ %{}) do
    {:ok, participant_chip} =
      attrs
      |> Enum.into(%{
        code: "some code",
        quantity: 42,
        reg_or_tag: "some reg_or_tag"
      })
      |> N1gp.Tournments.create_participant_chip()

    participant_chip
  end
end
