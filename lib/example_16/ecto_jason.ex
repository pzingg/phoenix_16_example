defmodule Ecto.Jason do
  @moduledoc """
  A custom Ecto.Type that lets us edit PostgreSQL :json
  database fields as JSON-encoded strings, and enforces
  the required map type.
  """
  use Ecto.Type

  def type, do: :map

  # No special cast needed for nil or maps
  def cast(nil), do: {:ok, nil}
  def cast(map) when is_map(map), do: {:ok, map}

  # Cast JSON strings into a map
  def cast(str) when is_binary(str) do
    case Jason.decode(str, keys: :strings) do
      {:ok, decoded} when is_map(decoded) ->
        {:ok, decoded}

      _ ->
        :error
    end
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, as long as it's a map,
  # or nil we just return the data back to be stored in
  # the loaded schema struct.
  def load(nil), do: {:ok, nil}
  def load(data) when is_map(data), do: {:ok, data}
  def load(_), do: :error

  # When dumping data to the database, we *expect* a map
  # but any value could be inserted into the schema struct at runtime,
  # so we need to guard against them.
  def dump(nil), do: {:ok, %{}}
  def dump(data) when is_map(data), do: {:ok, data}
  def dump(_), do: :error
end
