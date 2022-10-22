defmodule N1gp.Repo.Migrations.CreateRoundsParticipants do
  use Ecto.Migration

  def change do
    create table(:rounds_participants, primary_key: false) do
      add :challonge_id, :integer
      add :round_id, references(:rounds, on_delete: :delete_all)
      add :participant_id, references(:participants, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:rounds_participants, [:challonge_id])
    create unique_index(:rounds_participants, [:round_id, :participant_id])
    create index(:rounds_participants, [:round_id])
    create index(:rounds_participants, [:participant_id])
  end
end
