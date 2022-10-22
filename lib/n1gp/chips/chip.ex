defmodule N1gp.Chips.Chip do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chips" do
    field :aliases, {:array, :string}, default: []
    field :atk, :integer
    field :codes, {:array, :string}, default: []
    field :description, :string
    field :elements, {:array, :string}, default: []
    field :image, :string
    field :mb, :integer
    field :more_details, {:array, :string}, default: []
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(chip, attrs) do
    chip
    |> cast(attrs, [:name, :elements, :mb, :atk, :codes, :description, :image, :more_details, :aliases])
    |> validate_required([:name, :elements, :codes])
    |> unique_constraint(:name)
  end
end
