defmodule N1gp.Chips do
  @moduledoc """
  The Chips context.
  """

  import Ecto.Query, warn: false
  alias N1gp.Repo

  alias N1gp.Chips.Chip

  def import_chips do
    Repo.transaction(fn ->
      N1gp.Importer.import_chips()
      |> Enum.map(fn chip ->
        fields = [:elements, :mb, :atk, :codes, :description, :image, :more_details, :aliases]

        create_chip(chip, conflict_target: :name, on_conflict: {:replace, fields})
      end)
      |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
    end)
  end

  @doc """
  Returns the list of chips.

  ## Examples

      iex> list_chips()
      [%Chip{}, ...]

  """
  def list_chips do
    Repo.all(Chip)
  end

  @doc """
  Gets a single chip.

  Raises `Ecto.NoResultsError` if the Chip does not exist.

  ## Examples

      iex> get_chip!(123)
      %Chip{}

      iex> get_chip!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chip!(id), do: Repo.get!(Chip, id)

  @doc """
  Creates a chip.

  ## Examples

      iex> create_chip(%{field: value})
      {:ok, %Chip{}}

      iex> create_chip(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chip(attrs \\ %{}, opts \\ []) do
    %Chip{}
    |> Chip.changeset(attrs)
    |> Repo.insert(opts)
  end

  @doc """
  Updates a chip.

  ## Examples

      iex> update_chip(chip, %{field: new_value})
      {:ok, %Chip{}}

      iex> update_chip(chip, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chip(%Chip{} = chip, attrs) do
    chip
    |> Chip.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chip.

  ## Examples

      iex> delete_chip(chip)
      {:ok, %Chip{}}

      iex> delete_chip(chip)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chip(%Chip{} = chip) do
    Repo.delete(chip)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chip changes.

  ## Examples

      iex> change_chip(chip)
      %Ecto.Changeset{data: %Chip{}}

  """
  def change_chip(%Chip{} = chip, attrs \\ %{}) do
    Chip.changeset(chip, attrs)
  end
end
