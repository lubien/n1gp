defmodule N1gpWeb.TournmentLive.Show do
  use N1gpWeb, :live_view

  alias N1gp.Tournments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tournment, Tournments.get_tournment!(id))}
  end

  defp page_title(:show), do: "Show Tournment"
  defp page_title(:edit), do: "Edit Tournment"
end
