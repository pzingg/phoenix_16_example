defmodule Example16Web.ResultLive.Show do
  use Example16Web, :live_view

  alias Example16.Workspace

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> default_assigns()}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:result, Workspace.get_result!(id))}
  end

  defp page_title(:show), do: "Show Result"
  defp page_title(:edit), do: "Edit Result"
end
