defmodule Example16.Workspace.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  @timestamps_opts [type: :utc_datetime_usec]
  schema "projects" do
    field :type, :string
    field :name, :string
    field :description, :string
    field :design_cost, :decimal
    field :generation, :integer
    field :remaining, :integer
    field :completed?, :boolean, default: false
    belongs_to :user, Example16.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :type, :design_cost, :generation, :remaining, :completed?])
    |> validate_required([:name, :description, :type, :design_cost, :generation, :remaining, :completed?])
  end
end
