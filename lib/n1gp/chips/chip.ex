defmodule N1gp.Chips.Chip do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chips" do
    field :aliases, {:array, :string}
    field :atk, :integer
    field :codes, {:array, :string}
    field :description, :string
    field :elements, {:array, :string}
    field :image, :string
    field :mb, :integer
    field :more_details, {:array, :string}
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(chip, attrs) do
    chip
    |> cast(attrs, [:name, :elements, :mb, :atk, :codes, :description, :image, :more_details, :aliases])
    |> validate_required([:name, :elements, :mb, :atk, :codes, :description, :image, :more_details, :aliases])
    |> unique_constraint(:name)
  end
end
