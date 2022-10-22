defmodule N1gp.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :challonge_id, :string
      add :name, :string
      add :type, :string
      add :started_at, :utc_datetime
      add :completed_at, :utc_datetime
      add :position, :integer
      add :tournment_id, references(:tournments, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:rounds, [:tournment_id, :position])
    create unique_index(:rounds, [:challonge_id])
    create index(:rounds, [:tournment_id])
  end
end
