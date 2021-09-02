defmodule Example16Web.ProgressLive.Index do
  use Example16Web, :live_view

  alias Example16.Workspace
  alias Example16.Workspace.Progress

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> default_assigns()
     |> assign(:progress_collection, list_progress())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Progress")
    |> assign(:progress, Workspace.get_progress!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Progress")
    |> assign(:progress, %Progress{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Progress")
    |> assign(:progress, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    progress = Workspace.get_progress!(id)
    {:ok, _} = Workspace.delete_progress(progress)

    {:noreply, assign(socket, :progress_collection, list_progress())}
  end

  defp list_progress do
    Workspace.list_progress()
  end
end
