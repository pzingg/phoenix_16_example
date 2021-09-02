defmodule Example16Web.TaskLive.FormComponent do
  use Example16Web, :live_component

  alias Example16.Workspace

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
    task_params =
      to_utc_datetimes(
        task_params,
        ["started_at", "cancelled_at", "completed_at"],
        socket.assigns.tz,
        event: "validate"
      )

    changeset =
      socket.assigns.task
      |> Workspace.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  # HTML datetime-local produces 2021-03-01T20:00
  def handle_event("save", %{"task" => task_params}, socket) do
    task_params =
      to_utc_datetimes(
        task_params,
        ["started_at", "cancelled_at", "completed_at"],
        socket.assigns.tz,
        event: "save"
      )

    save_task(socket, socket.assigns.action, task_params)
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
