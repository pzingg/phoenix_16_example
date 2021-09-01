defmodule Example16Web.InputHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  def json_encoded(changeset, field) do
    case Ecto.Changeset.get_field(changeset, field) do
      data when is_map(data) ->
        Jason.encode!(data, pretty: true)
      _ ->
        ""
    end
  end
end
