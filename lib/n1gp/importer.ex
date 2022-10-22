defmodule N1gp.Importer do
  alias N1gp.Importer.Spreadsheet

  @manual_mappings %{
    "DR.TBB2#3787" => "TBB2",
    "weenie#1984" => "weenie"
  }

  def import_chips do
    Path.join([File.cwd!, "./priv/chip_library.json"])
    |> File.read!()
    |> Jason.decode!()
    |> Enum.map(&parse_chip/1)
  end

  def parse_chip(raw) do
    %{
      name: raw["Name"],
      elements: parse_chip_list(raw["Element"], "/"),
      mb: parse_chip_int(raw["MB"]),
      atk: parse_chip_int(raw["ATK"]),
      codes: parse_chip_list(raw["Codes"], " "),
      description: parse_chip_or_nil(raw["Description"]),
      image: parse_chip_or_nil(raw["Image"]),
      more_details: parse_chip_list(raw["MoreDetails"]),
      aliases: parse_chip_list(raw["Alias"]),
    }
  end

  def parse_chip_int(nil), do: nil
  def parse_chip_int("--"), do: nil
  def parse_chip_int("????"), do: nil
  def parse_chip_int(mb) do
    case Integer.parse(mb) do
      {int, _rest} ->
        int

      _ ->
        mb
    end
  end

  def parse_chip_list(nil, _separator), do: []
  def parse_chip_list("--", _separator), do: []
  def parse_chip_list(str, separator \\ ",") do
    str
    |> String.split(separator)
    |> Enum.map(&String.trim/1)
  end

  def parse_chip_or_nil(nil), do: nil
  def parse_chip_or_nil(""), do: nil
  def parse_chip_or_nil(raw), do: raw

  def import_tournment(opts) do
    name = Keyword.fetch!(opts, :name)
    key = Keyword.fetch!(opts, :key)
    type = Keyword.fetch!(opts, :type)
    # rounds = Keyword.fetch!(opts, :rounds)

    participants = Spreadsheet.get_participants(key)

    # rounds = Enum.map(rounds, &get_round(&1, participants))

    %{
      key: key,
      name: name,
      type: type,
      # rounds: rounds,
      participants: participants
    }
  end

  def get_round(round, participants) do
    challonge_tournment =
      File.read!("priv/tournments/nv2022c12bm3/round-robin/tournment.json")
      |> Jason.decode!()
      |> Map.get("tournament")

    challonge_participants =
      File.read!("priv/tournments/nv2022c12bm3/round-robin/participants.json")
      |> Jason.decode!()

    challonge_matches =
      File.read!("priv/tournments/nv2022c12bm3/round-robin/matches.json")
      |> Jason.decode!()

    round_participants = map_participants_to_challonge_participants(participants, challonge_participants)

    round_participants_by_challonge_id =
      round_participants
      |> Enum.map(& {&1.challonge_id, &1})
      |> Enum.into(%{})

    matches = map_matches(challonge_matches, round_participants_by_challonge_id)

    %{
      name: challonge_tournment["name"],
      challonge_id: challonge_tournment["url"],
      tournament_type: challonge_tournment["tournament_type"],
      participants: round_participants,
      matches: matches
    }
  end

  def map_participants_to_challonge_participants(participants, challonge_participants) do
    %{
      exact: exact_matches,
      unknown: unknowns
    } =
      challonge_participants
      |> Enum.group_by(fn remote ->
        if Enum.any?(participants, &same_name_on_challonge?(&1, remote)) do
          :exact
        else
          :unknown
        end
      end)

    exact_matches =
      exact_matches
      |> Enum.group_by(& String.downcase(&1["participant"]["name"]))

    participants
    |> Enum.map(fn local ->
      remote = match_local_with_challonge_participant(local, exact_matches, unknowns)

      %{
        name: local.name,
        entrant_no: local.entrant_no,
        challonge_id: remote["participant"]["id"]
      }
    end)
  end

  def same_name_on_challonge?(local, remote) do
    String.downcase(local.name) == String.downcase(remote["participant"]["display_name"])
  end

  def match_local_with_challonge_participant(local, exact_matches, unknowns) do
    if matched = exact_matches[String.downcase(local.name)] do
      List.first(matched)
    else
      unknowns
      |> Enum.find(fn remote ->
        {Map.drop(local, [:a]), remote["participant"]["display_name"]} |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
        @manual_mappings[local.discord_name] == remote["participant"]["display_name"] ||
        # TODO: improve
        String.bag_distance(remote["participant"]["name"], local.name) >= 0.5
      end)
    end
  end

  def map_matches(challonge_matches, round_participants_by_challonge_id) do
    challonge_matches
    |> Enum.map(fn %{"match" => match} ->
      %{
        challonge_id: match["id"],
        state: match["state"],
        participant1_id: round_participants_by_challonge_id[match["player1_id"]][:entrant_no],
        participant2_id: round_participants_by_challonge_id[match["player2_id"]][:entrant_no],
        winner_id: round_participants_by_challonge_id[match["winner_id"]][:entrant_no],
        started_at: parse_datetime(match["started_at"]),
        completed_at: parse_datetime(match["completed_at"])
      }
    end)
  end

  def parse_datetime(nil) do
    nil
  end
  def parse_datetime(date) do
    case DateTime.from_iso8601(date) do
      {:ok, datetime, _offset} ->
        datetime

      _ ->
        nil
    end
  end
end
