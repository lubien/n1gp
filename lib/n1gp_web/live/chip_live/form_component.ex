defmodule N1gpWeb.ChipLive.FormComponent do
  use N1gpWeb, :live_component

  alias N1gp.Chips

  @impl true
  def update(%{chip: chip} = assigns, socket) do
    changeset = Chips.change_chip(chip)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"chip" => chip_params}, socket) do
    changeset =
      socket.assigns.chip
      |> Chips.change_chip(chip_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"chip" => chip_params}, socket) do
    save_chip(socket, socket.assigns.action, chip_params)
  end

  defp save_chip(socket, :edit, chip_params) do
    case Chips.update_chip(socket.assigns.chip, chip_params) do
      {:ok, _chip} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chip updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_chip(socket, :new, chip_params) do
    case Chips.create_chip(chip_params) do
      {:ok, _chip} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chip created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
