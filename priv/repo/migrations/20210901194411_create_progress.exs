defmodule Example16.Repo.Migrations.CreateProgress do
  use Ecto.Migration

  def change do
    create table(:progress, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string
      add :description, :string
      add :completed, :integer
      add :total, :integer
      add :project_id, references(:projects, on_delete: :nothing, type: :binary_id)
      add :task_id, references(:tasks, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create index(:progress, [:project_id])
    create index(:progress, [:task_id])
  end
end
