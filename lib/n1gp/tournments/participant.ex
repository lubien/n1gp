defmodule N1gp.Tournments.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :discord_name, :string
    field :entrant_no, :integer
    field :name, :string
    field :navicust, {:array, :map}, default: []
    field :navicust_image, :string
    field :version, :string
    field :tournment_id, :id
    has_many :participant_chips, N1gp.Tournments.ParticipantChip
    many_to_many :chips, N1gp.Chips.Chip, join_through: "participants_chips"

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:entrant_no, :name, :discord_name, :version, :navicust_image, :navicust])
    |> validate_required([:entrant_no, :name, :discord_name, :version, :navicust_image, :navicust])
  end
end
