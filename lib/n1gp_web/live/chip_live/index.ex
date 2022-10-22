defmodule N1gpWeb.ChipLive.Index do
  use N1gpWeb, :live_view

  alias N1gp.Chips
  alias N1gp.Chips.Chip

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :chips, list_chips())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chip")
    |> assign(:chip, Chips.get_chip!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chip")
    |> assign(:chip, %Chip{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Chips")
    |> assign(:chip, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chip = Chips.get_chip!(id)
    {:ok, _} = Chips.delete_chip(chip)

    {:noreply, assign(socket, :chips, list_chips())}
  end

  defp list_chips do
    Chips.list_chips()
  end
end
