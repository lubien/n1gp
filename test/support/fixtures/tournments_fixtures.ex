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
end
