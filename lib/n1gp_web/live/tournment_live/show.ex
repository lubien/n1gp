defmodule N1gpWeb.TournmentLive.Show do
  use N1gpWeb, :live_view

  alias N1gp.Tournments

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, get_tournment(socket, id)}
  end

  @impl true
  def handle_params(%{"id" => _id, "round_id" => round_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, :round)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:round, Enum.find(socket.assigns.tournment.rounds, & &1.id == round_id))
     }
  end

  def handle_params(%{"id" => _id, "participant_id" => participant_id}, _, socket) do
    participant = Enum.find(socket.assigns.tournment.participants, & Integer.to_string(&1.id) == participant_id)
    participant_chips =
      participant.participant_chips
      |> Enum.map(fn pc -> {Enum.find(participant.chips, & &1.id == pc.chip_id), pc} end)
      |> Enum.sort_by(fn {_c, pc} -> pc.inserted_at end, :asc)

    {:noreply,
     socket
     |> assign(:current_tab, :participant)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:participant, participant)
     |> assign(:participant_chips, participant_chips)
    }
  end

  def handle_params(_params, _, %{assigns: %{live_action: :stats}} = socket) do
    {:noreply,
     socket
     |> calculte_stats()
     |> assign(:current_tab, :stats)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     }
  end

  def handle_params(_params, _, %{assigns: %{live_action: :most_used_chips}} = socket) do
    participant_chips = Tournments.load_participant_chips(socket.assigns.tournment.id)
    chip_usage_breakdown = Tournments.calculate_participant_chips_breakdown(participant_chips)

    {:noreply,
     socket
     |> assign(:current_tab, :most_used_chips)
     |> assign(:participant_chips, participant_chips)
     |> assign(:chip_usage_breakdown, chip_usage_breakdown)
     |> assign(:page_title, page_title(socket.assigns.live_action))
    }
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, :home)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     }
  end

  def get_tournment(socket, id) do
    tournment = Tournments.get_tournment!(id)

    socket
    |> assign(:tournment, tournment)
    |> assign(:round, nil)
    |> assign(:participants, Enum.sort_by(tournment.participants, & &1.entrant_no))
    |> assign(:match_breakdown, Tournments.calculate_matches_breakdown(tournment.matches))
  end

  def calculte_stats(%{assigns: %{tournment: tournment}} = socket) do
    most_wins =
      socket.assigns.match_breakdown
      |> Enum.sort_by(fn {_id, stat} -> stat.won end, :desc)
      |> List.first()
      |> elem(1)
      |> Map.get(:won)

    most_losses =
      socket.assigns.match_breakdown
      |> Enum.sort_by(fn {_id, stat} -> stat.lost end, :desc)
      |> List.first()
      |> elem(1)
      |> Map.get(:lost)

    most_forfeited =
      socket.assigns.match_breakdown
      |> Enum.sort_by(fn {_id, stat} -> stat.forfeited end, :desc)
      |> List.first()
      |> elem(1)
      |> Map.get(:forfeited)

    stats = %{
      most_wins: Enum.filter(tournment.participants, & socket.assigns.match_breakdown[&1.id].won == most_wins),
      most_wins_count: most_wins,
      most_losses: Enum.filter(tournment.participants, & socket.assigns.match_breakdown[&1.id].lost == most_losses),
      most_losses_count: most_losses,
      most_forfeited: Enum.filter(tournment.participants, & socket.assigns.match_breakdown[&1.id].lost == most_forfeited),
      most_forfeited_count: most_forfeited,
    }

    socket
    |> assign(:stats, stats)
  end

  defp page_title(:show), do: "Show Tournment"
  defp page_title(:stats), do: "Show Tournment"
  defp page_title(:participant), do: "Show Tournment"
  defp page_title(:most_used_chips), do: "Show Tournment"
  defp page_title(:edit), do: "Edit Tournment"
end
