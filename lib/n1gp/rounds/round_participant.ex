defmodule N1gp.Rounds.RoundParticipant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "rounds_participants" do
    field :challonge_id, :integer
    field :round_id, :id
    field :participant_id, :id

    timestamps()
  end

  @doc false
  def changeset(round_participant, attrs) do
    round_participant
    |> cast(attrs, [:challonge_id])
    |> validate_required([:challonge_id])
    |> unique_constraint(:challonge_id)
  end
end
