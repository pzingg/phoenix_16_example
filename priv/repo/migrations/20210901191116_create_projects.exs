defmodule Example16.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :type, :string
      add :name, :string
      add :description, :string
      add :design_cost, :decimal
      add :generation, :integer
      add :remaining, :integer
      add :completed?, :boolean, default: false, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:projects, [:user_id])
  end
end
