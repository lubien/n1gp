defmodule N1gp.Tournments do
  @moduledoc """
  The Tournments context.
  """

  import Ecto.Query, warn: false
  alias N1gp.Repo

  alias N1gp.Tournments.Tournment

  def import_tournment(attrs) do
    Repo.transaction(fn ->
      attrs
      |> N1gp.Importer.import_tournment()
      |> create_tournment(conflict_target: :key, on_conflict: {:replace, [:name, :type]})
      |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
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
  def get_tournment!(id), do: Repo.get!(Tournment, id)

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
end
