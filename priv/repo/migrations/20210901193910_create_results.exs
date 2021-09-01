defmodule Example16.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :description, :string
      add :generation, :integer
      add :data, :map
      add :errors, :map
      add :project_id, references(:projects, on_delete: :nothing, type: :binary_id)
      add :task_id, references(:tasks, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create index(:results, [:project_id])
    create index(:results, [:task_id])
  end
end
