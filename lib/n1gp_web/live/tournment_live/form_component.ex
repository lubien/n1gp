defmodule N1gpWeb.TournmentLive.FormComponent do
  use N1gpWeb, :live_component

  alias N1gp.Tournments

  @impl true
  def update(%{tournment: tournment} = assigns, socket) do
    changeset = Tournments.change_tournment(tournment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tournment" => tournment_params}, socket) do
    changeset =
      socket.assigns.tournment
      |> Tournments.change_tournment(tournment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tournment" => tournment_params}, socket) do
    save_tournment(socket, socket.assigns.action, tournment_params)
  end

  defp save_tournment(socket, :edit, tournment_params) do
    case Tournments.update_tournment(socket.assigns.tournment, tournment_params) do
      {:ok, _tournment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tournment updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tournment(socket, :new, tournment_params) do
    case Tournments.create_tournment(tournment_params) do
      {:ok, _tournment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tournment created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
