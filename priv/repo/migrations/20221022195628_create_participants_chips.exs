defmodule N1gp.Repo.Migrations.CreateParticipantsChips do
  use Ecto.Migration

  def change do
    create table(:participants_chips, primary_key: false) do
      add :quantity, :integer
      add :code, :string
      add :reg_or_tag, :string
      add :participant_id, references(:participants, on_delete: :delete_all)
      add :chip_id, references(:chips, on_delete: :delete_all)

      timestamps()
    end

    create index(:participants_chips, [:participant_id])
    create index(:participants_chips, [:chip_id])
    create unique_index(:participants_chips, [:chip_id, :participant_id])
  end
end
