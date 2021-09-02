defmodule Example16.Workspace.Result do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  @timestamps_opts [type: :utc_datetime_usec]
  schema "results" do
    field :type, :string
    field :description, :string
    field :generation, :integer
    field :data, Ecto.Jason
    field :errors, Ecto.Jason
    belongs_to :project, Example16.Workspace.Project
    belongs_to :task, Example16.Workspace.Task

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [:type, :description, :generation, :data, :errors])
    |> validate_required([:type, :description, :generation])
  end
end
