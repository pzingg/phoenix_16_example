defmodule Example16.Workspace.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  @timestamps_opts [type: :utc_datetime_usec]
  schema "tasks" do
    field :type, :string
    field :description, :string
    field :generation, :integer
    field :status, :string
    field :started_at, :utc_datetime_usec
    field :cancelled_at, :utc_datetime_usec
    field :completed_at, :utc_datetime_usec
    belongs_to :project, Example16.Workspace.Project

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:type, :description, :generation, :status, :started_at, :cancelled_at, :completed_at])
    |> validate_required([:type, :description, :generation, :status])
    |> local_to_utc([:started_at, :cancelled_at, :completed_at])
  end

  defp local_to_utc(changeset, _fields) do
    # TODO: get timezone from changeset and convert from naive to UTC
    changeset
  end
end
