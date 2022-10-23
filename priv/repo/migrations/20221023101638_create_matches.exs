defmodule N1gp.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :challonge_id, :integer
      add :started_at, :utc_datetime
      add :completed_at, :utc_datetime
      add :scores_csv, :string
      add :state, :string
      add :round_id, references(:rounds, on_delete: :delete_all)
      add :participant1_id, references(:participants, on_delete: :delete_all)
      add :participant2_id, references(:participants, on_delete: :delete_all)
      add :winner_id, references(:participants, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:matches, [:challonge_id])
    create index(:matches, [:round_id])
    create index(:matches, [:participant1_id])
    create index(:matches, [:participant2_id])
    create index(:matches, [:winner_id])
  end
end
