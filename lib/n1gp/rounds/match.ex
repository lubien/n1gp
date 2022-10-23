defmodule N1gp.Rounds.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :challonge_id, :integer
    field :completed_at, :utc_datetime
    field :scores_csv, :string
    field :started_at, :utc_datetime
    field :state, :string
    field :round_id, :id
    field :participant1_id, :id
    field :participant2_id, :id
    field :winner_id, :id
    field :challonge_round, :integer
    field :forfeited, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:challonge_id, :started_at, :completed_at, :scores_csv, :state])
    |> validate_required([:challonge_id, :started_at, :completed_at, :scores_csv, :state])
    |> unique_constraint(:challonge_id)
  end
end
