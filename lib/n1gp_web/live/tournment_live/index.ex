defmodule N1gpWeb.TournmentLive.Index do
  use N1gpWeb, :live_view

  alias N1gp.Tournments
  alias N1gp.Tournments.Tournment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tournments, list_tournments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tournment")
    |> assign(:tournment, Tournments.get_tournment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tournment")
    |> assign(:tournment, %Tournment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tournments")
    |> assign(:tournment, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tournment = Tournments.get_tournment!(id)
    {:ok, _} = Tournments.delete_tournment(tournment)

    {:noreply, assign(socket, :tournments, list_tournments())}
  end

  defp list_tournments do
    Tournments.list_tournments()
  end
end
