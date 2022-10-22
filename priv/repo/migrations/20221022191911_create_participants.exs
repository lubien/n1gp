defmodule N1gp.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :entrant_no, :integer
      add :name, :string
      add :discord_name, :string
      add :version, :string
      add :navicust_image, :string
      add :navicust, {:array, :map}, default: []
      add :tournment_id, references(:tournments, on_delete: :delete_all)

      timestamps()
    end

    create index(:participants, [:tournment_id])
    create unique_index(:participants, [:tournment_id, :entrant_no])
  end
end
