defmodule N1gpWeb.ChipLive.Show do
  use N1gpWeb, :live_view

  alias N1gp.Chips

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:chip, Chips.get_chip!(id))}
  end

  defp page_title(:show), do: "Show Chip"
  defp page_title(:edit), do: "Edit Chip"
end
