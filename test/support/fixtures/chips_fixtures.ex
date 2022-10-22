defmodule N1gp.ChipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `N1gp.Chips` context.
  """

  @doc """
  Generate a unique chip name.
  """
  def unique_chip_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a chip.
  """
  def chip_fixture(attrs \\ %{}) do
    {:ok, chip} =
      attrs
      |> Enum.into(%{
        aliases: [],
        atk: 42,
        codes: [],
        description: "some description",
        elements: [],
        image: "some image",
        mb: 42,
        more_details: [],
        name: unique_chip_name()
      })
      |> N1gp.Chips.create_chip()

    chip
  end
end
