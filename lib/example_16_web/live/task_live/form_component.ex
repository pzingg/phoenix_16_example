defmodule Example16Web.TaskLive.FormComponent do
  use Example16Web, :live_component

  alias Example16.Workspace

  require Logger

  @impl true
  def update(%{task: task} = assigns, socket) do
    changeset = Workspace.change_task(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.task
      |> Workspace.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  # HTML datetime-local produces 2021-03-01T20:00
  def handle_event("save", %{"task" => task_params}, socket) do
    started_at = Map.get(task_params, "started_at")
    Logger.error("saving started_at '#{inspect(started_at)}'")
    task_params = fix_datetime_local_values(task_params, ["started_at", "cancelled_at", "completed_at"])
    started_at = Map.get(task_params, "started_at")
    Logger.error("now started_at '#{inspect(started_at)}'")
    save_task(socket, socket.assigns.action, task_params)
  end

  defp fix_datetime_local_values(params, keys) do
    Enum.reduce(keys, params, &fix_datetime_local_value(&2, &1))
  end

  defp fix_datetime_local_value(params, key) do
    if Map.has_key?(params, key) do
      case cast_utc_datetime(Map.get(params, key)) do
        {:ok, dt} ->
          Map.put(params, key, dt)
        _ ->
          params
      end
    else
      params
    end
  end

  defp cast_utc_datetime(nil), do: nil
  defp cast_utc_datetime(""), do: nil
  defp cast_utc_datetime(dt_str) when is_binary(dt_str) do
    case Timex.parse(dt_str, "{ISO:Extended}") do
      {:ok, %NaiveDateTime{} = naive_datetime} ->
        {:ok,
            naive_datetime
            |> Timex.to_datetime("America/Los_Angeles")
            |> Timex.to_datetime("Etc/UTC") }
      {:ok, %DateTime{} = datetime} ->
        {:ok,
            datetime
            |> Timex.to_datetime("Etc/UTC") }
      error ->
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

  defp save_task(socket, :edit, task_params) do
    case Workspace.update_task(socket.assigns.task, task_params) do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_task(socket, :new, task_params) do
    case Workspace.create_task(task_params) do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
