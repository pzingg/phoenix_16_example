defmodule Example16Web.InputHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  require Logger

  def json_encoded(changeset, field) do
    case Ecto.Changeset.get_field(changeset, field) do
      data when is_map(data) ->
        Jason.encode!(data, pretty: true)

      _ ->
        ""
    end
  end

  def to_utc_datetimes(params, keys, tz, opts) do
    Enum.reduce(keys, params, &to_utc_datetime(&2, &1, tz, opts))
  end

  def to_utc_datetime(params, key, tz, opts) do
    if Map.has_key?(params, key) do
      case cast_utc_datetime(Map.get(params, key), tz, Keyword.put(opts, :field, key)) do
        {:ok, dt} ->
          Map.put(params, key, dt)

        _ ->
          params
      end
    else
      params
    end
  end

  defp cast_utc_datetime(nil, _tz, _opts), do: nil
  defp cast_utc_datetime("", _tz, _opts), do: nil

  defp cast_utc_datetime(dt_str, tz, opts) when is_binary(dt_str) do
    event = Keyword.get(opts, :event)
    field = Keyword.get(opts, :field)

    case Timex.parse(dt_str, "{YYYY}-{0M}-{0D} {h24}:{m}:{s}") do
      {:ok, %NaiveDateTime{} = naive_datetime} ->
        Logger.error("#{event} #{field} parsed naive #{dt_str}")

        {:ok,
         naive_datetime
         |> Timex.to_datetime(tz)
         |> Timex.to_datetime("Etc/UTC")}

      {:ok, %DateTime{} = datetime} ->
        Logger.error("#{event} #{field} parsed tz #{dt_str}")

        {:ok,
         datetime
         |> Timex.to_datetime("Etc/UTC")}

      {:error, reason} = error ->
        Logger.error("#{event} #{field} FAILED #{inspect(reason)} #{dt_str}")
        error
    end
  end

  defp to_i(nil), do: nil
  defp to_i(int) when is_integer(int), do: int

  defp to_i(bin) when is_binary(bin) do
    case Integer.parse(bin) do
      {int, ""} -> int
      _ -> nil
    end
  end

  def as_local_datetime(%Ecto.Changeset{} = changeset, field, tz, opts \\ []) do
    to_local_datetime(Ecto.Changeset.get_field(changeset, field), tz, opts)
  end

  def to_local_datetime(datetime, tz, opts \\ [])
  def to_local_datetime(nil, _tz, _opts), do: ""

  def to_local_datetime(%DateTime{} = datetime, tz, opts) do
    {datetime, _tz, _prefix} =
      case tz do
        nil -> {datetime, "Etc/UTC", "UTC"}
        tz -> {Timex.to_datetime(datetime, tz), tz, nil}
      end

    format =
      if Keyword.get(opts, :naive, false) do
        "{YYYY}-{0M}-{0D} {h24}:{m}:{s}"
      else
        "{YYYY}-{0M}-{0D} {h24}:{m}:{s} {Zabbr}"
      end

    Timex.format!(datetime, format)
  end
end
