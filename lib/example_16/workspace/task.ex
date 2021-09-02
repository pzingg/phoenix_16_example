defmodule Example16.Workspace.Task do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  @timestamps_opts [type: :utc_datetime_usec]
  schema "tasks" do
    field :type, :string
    field :description, :string
    field :generation, :integer
    field :status, :string
    field :tz, :string, virtual: true
    field :started_at, :utc_datetime_usec
    field :cancelled_at, :utc_datetime_usec
    field :completed_at, :utc_datetime_usec
    belongs_to :project, Example16.Workspace.Project

    timestamps()
  end

  @default_time_zone "America/Los_Angeles"

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :type,
      :description,
      :generation,
      :status,
      :tz,
      :started_at,
      :cancelled_at,
      :completed_at
    ])
    |> validate_required([:type, :description, :generation, :status])
    |> ensure_timezone(@default_time_zone)
    |> local_to_utc([:started_at, :cancelled_at, :completed_at])
    |> Ecto.Changeset.delete_change(:tz)
  end

  defp ensure_timezone(changeset, default_time_zone) do
    case Ecto.Changeset.get_field(changeset, :tz) do
      nil ->
        Ecto.Changeset.put_change(changeset, :tz, default_time_zone)

      _ ->
        changeset
    end
  end

  defp local_to_utc(changeset, fields) do
    tz = Ecto.Changeset.get_field(changeset, :tz)
    Enum.reduce(fields, changeset, &do_local_to_utc(&2, &1, tz))
  end

  defp do_local_to_utc(changeset, field, tz) do
    case Ecto.Changeset.get_field(changeset, field) do
      nil ->
        changeset

      %NaiveDateTime{} = dt_naive ->
        dt_utc =
          dt_naive
          |> Timex.to_datetime(tz)
          |> Timex.to_datetime("Etc/UTC")

        Logger.warn("converted naive #{dt_naive} with tz #{tz} to UTC #{dt_utc}")
        Ecto.Changeset.put_change(changeset, field, dt_utc)

      %DateTime{} = dt_local ->
        dt_utc =
          dt_local
          |> Timex.to_datetime("Etc/UTC")

        Ecto.Changeset.put_change(changeset, field, dt_utc)
    end
  end
end
