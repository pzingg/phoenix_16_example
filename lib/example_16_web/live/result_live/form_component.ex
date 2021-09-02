defmodule Example16Web.ResultLive.FormComponent do
  use Example16Web, :live_component

  alias Example16.Workspace

  require Logger

  @impl true
  def update(%{result: result} = assigns, socket) do
    changeset = Workspace.change_result(result)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"result" => result_params}, socket) do
    changeset =
      socket.assigns.result
      |> Workspace.change_result(result_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"result" => result_params}, socket) do
    save_result(socket, socket.assigns.action, result_params)
  end

  defp save_result(socket, :edit, result_params) do
    case Workspace.update_result(socket.assigns.result, result_params) do
      {:ok, _result} ->
        {:noreply,
         socket
         |> put_flash(:info, "Result updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn("update_result failed: #{inspect(changeset.errors)}")
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_result(socket, :new, result_params) do
    case Workspace.create_result(result_params) do
      {:ok, _result} ->
        {:noreply,
         socket
         |> put_flash(:info, "Result created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn("create_result failed: #{inspect(changeset.errors)}")
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
