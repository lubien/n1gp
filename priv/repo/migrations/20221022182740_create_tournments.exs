defmodule N1gp.Repo.Migrations.CreateTournments do
  use Ecto.Migration

  def change do
    create table(:tournments) do
      add :key, :string
      add :name, :string
      add :type, :string

      timestamps()
    end

    create unique_index(:tournments, [:key])
  end
end
