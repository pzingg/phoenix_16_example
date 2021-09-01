defmodule Example16Web.ProgressLive.Show do
  use Example16Web, :live_view

  alias Example16.Workspace

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:progress, Workspace.get_progress!(id))}
  end

  defp page_title(:show), do: "Show Progress"
  defp page_title(:edit), do: "Edit Progress"
end
