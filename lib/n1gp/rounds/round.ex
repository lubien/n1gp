defmodule N1gp.Rounds.Round do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rounds" do
    field :challonge_id, :string
    field :completed_at, :utc_datetime
    field :name, :string
    field :position, :integer
    field :started_at, :utc_datetime
    field :type, :string
    field :tournment_id, :id

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:challonge_id, :name, :type, :started_at, :completed_at, :position])
    |> validate_required([:challonge_id, :name, :type, :started_at, :completed_at, :position])
    |> unique_constraint(:challonge_id)
  end
end
