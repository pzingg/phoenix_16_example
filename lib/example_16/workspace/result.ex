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
    field :data_json, :string, virtual: true
    field :data, :map
    field :errors_json, :string, virtual: true
    field :errors, :map
    belongs_to :project, Example16.Workspace.Project
    belongs_to :task, Example16.Workspace.Task

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [:type, :description, :generation, :data_json, :errors_json])
    |> validate_required([:type, :description, :generation])
    |> encode_data()
    |> encode_errors()
  end

  def encode_data(changeset) do
      case Ecto.Changeset.get_field(changeset, :data_json) do
        nil ->
          Ecto.Changeset.put_change(changeset, :data, %{})
        str ->
          case Jason.decode(str, keys: :atoms) do
            {:ok, decoded} when is_map(decoded) ->
              Ecto.Changeset.put_change(changeset, :data, decoded)
            _ ->
              Ecto.Changeset.add_error(changeset, :data, "must be valid JSON object")
          end
      end
  end

  def encode_errors(changeset) do
    case Ecto.Changeset.get_field(changeset, :errors_json) do
      nil ->
        Ecto.Changeset.put_change(changeset, :errors, %{})
      str ->
        case Jason.decode(str, keys: :atoms) do
          {:ok, decoded} when is_map(decoded) ->
            Ecto.Changeset.put_change(changeset, :errors, decoded)
          _ ->
            Ecto.Changeset.add_error(changeset, :errors, "must be valid JSON object")
        end
    end
  end

end
