defmodule Example16Web.ProgressLive.FormComponent do
  use Example16Web, :live_component

  alias Example16.Workspace

  @impl true
  def update(%{progress: progress} = assigns, socket) do
    changeset = Workspace.change_progress(progress)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"progress" => progress_params}, socket) do
    changeset =
      socket.assigns.progress
      |> Workspace.change_progress(progress_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"progress" => progress_params}, socket) do
    save_progress(socket, socket.assigns.action, progress_params)
  end

  defp save_progress(socket, :edit, progress_params) do
    case Workspace.update_progress(socket.assigns.progress, progress_params) do
      {:ok, _progress} ->
        {:noreply,
         socket
         |> put_flash(:info, "Progress updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_progress(socket, :new, progress_params) do
    case Workspace.create_progress(progress_params) do
      {:ok, _progress} ->
        {:noreply,
         socket
         |> put_flash(:info, "Progress created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
