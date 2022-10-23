defmodule N1gp.Tournments.Tournment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tournments" do
    field :key, :string
    field :name, :string
    field :type, :string
    has_many :rounds, N1gp.Rounds.Round
    has_many :participants, N1gp.Tournments.Participant
    # has_many :participant_chips, through: [:participants, :participant_chips]
    has_many :chips, through: [:participants, :chips]
    has_many :matches, through: [:rounds, :matches]

    timestamps()
  end

  @doc false
  def changeset(tournment, attrs) do
    tournment
    |> cast(attrs, [:key, :name, :type])
    |> validate_required([:key, :name, :type])
    |> unique_constraint(:key)
    # |> cast_assoc(:participants, with: &N1gp.Tournments.Participant.changeset/2)
  end
end
