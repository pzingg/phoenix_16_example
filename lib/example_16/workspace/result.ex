defmodule Example16.Workspace.Result do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  @timestamps_opts [type: :utc_datetime_usec]
  schema "results" do
    field :type, :string
    field :description, :string
    field :generation, :integer
    field :data, :map
    field :errors, :map
    belongs_to :project, Example16.Workspace.Project
    belongs_to :task, Example16.Workspace.Task

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [:type, :description, :generation, :data, :errors])
    |> validate_required([:type, :description, :generation])
    # |> encode_json_maps([:data, :errors])
  end

  def encode_json_maps(changeset, fields) do
    Enum.reduce(fields, changeset, &encode_json_map(&2, &1))
  end

  def encode_json_map(changeset, field) do
    case Ecto.Changeset.get_field(changeset, field) do
      nil ->
        Ecto.Changeset.put_change(changeset, field, %{})
      str ->
        case Jason.decode(str, keys: :strings) do
          {:ok, decoded} when is_map(decoded) ->
            Ecto.Changeset.put_change(changeset, field, decoded)
          _ ->
            Ecto.Changeset.add_error(changeset, field, "must be valid JSON object")
        end
    end
  end
end
