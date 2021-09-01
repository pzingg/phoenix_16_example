defmodule Example16.Workspace.Progress do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  @timestamps_opts [type: :utc_datetime_usec]
  schema "progress" do
    field :status, :string
    field :description, :string
    field :completed, :integer
    field :total, :integer
    belongs_to :project, Example16.Workspace.Project
    belongs_to :task, Example16.Workspace.Task

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(progress, attrs) do
    progress
    |> cast(attrs, [:status, :description, :completed, :total])
    |> validate_required([:status, :description, :completed, :total])
  end
end
