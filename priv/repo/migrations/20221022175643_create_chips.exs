defmodule N1gp.Repo.Migrations.CreateChips do
  use Ecto.Migration

  def change do
    create table(:chips) do
      add :name, :string
      add :elements, {:array, :string}
      add :mb, :integer
      add :atk, :integer
      add :codes, {:array, :string}
      add :description, :string
      add :image, :string
      add :more_details, {:array, :string}
      add :aliases, {:array, :string}

      timestamps()
    end

    create unique_index(:chips, [:name])
  end
end
