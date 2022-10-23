defmodule N1gp.Repo.Migrations.AddMoreMatchFields do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :challonge_round, :integer
      add :forfeited, :boolean, default: false
    end
  end
end
