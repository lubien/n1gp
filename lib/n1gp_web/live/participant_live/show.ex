defmodule N1gpWeb.ParticipantLive.Show do
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
     |> assign(:participant, Tournments.get_participant!(id))}
  end

  defp page_title(:show), do: "Show Participant"
  defp page_title(:edit), do: "Edit Participant"
end
