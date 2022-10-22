defmodule N1gpWeb.ParticipantLive.FormComponent do
  use N1gpWeb, :live_component

  alias N1gp.Tournments

  @impl true
  def update(%{participant: participant} = assigns, socket) do
    changeset = Tournments.change_participant(participant)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"participant" => participant_params}, socket) do
    changeset =
      socket.assigns.participant
      |> Tournments.change_participant(participant_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"participant" => participant_params}, socket) do
    save_participant(socket, socket.assigns.action, participant_params)
  end

  defp save_participant(socket, :edit, participant_params) do
    case Tournments.update_participant(socket.assigns.participant, participant_params) do
      {:ok, _participant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Participant updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_participant(socket, :new, participant_params) do
    case Tournments.create_participant(participant_params) do
      {:ok, _participant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Participant created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
