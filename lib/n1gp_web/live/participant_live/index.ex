defmodule N1gpWeb.ParticipantLive.Index do
  use N1gpWeb, :live_view

  alias N1gp.Tournments
  alias N1gp.Tournments.Participant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :participants, list_participants())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Participant")
    |> assign(:participant, Tournments.get_participant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Participant")
    |> assign(:participant, %Participant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Participants")
    |> assign(:participant, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    participant = Tournments.get_participant!(id)
    {:ok, _} = Tournments.delete_participant(participant)

    {:noreply, assign(socket, :participants, list_participants())}
  end

  defp list_participants do
    Tournments.list_participants()
  end
end
