defmodule N1gp.Tournments.ParticipantChip do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "participants_chips" do
    field :code, :string
    field :quantity, :integer
    field :reg_or_tag, :string
    field :participant_id, :id
    field :chip_id, :id

    timestamps()
  end

  @doc false
  def changeset(participant_chip, attrs) do
    participant_chip
    |> cast(attrs, [:quantity, :code, :reg_or_tag])
    |> validate_required([:quantity, :code, :reg_or_tag])
  end
end
