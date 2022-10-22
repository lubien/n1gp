defmodule N1gp.Importer do
  @manual_mappings %{
    "DR.TBB2#3787" => "TBB2",
    "weenie#1984" => "weenie"
  }

  def import(opts) do
    name = Keyword.fetch!(opts, :name)
    key = Keyword.fetch!(opts, :key)
    rounds = Keyword.fetch!(opts, :rounds)

    participants = N1gp.Spreadsheet.get_participants("nv2022c12bm3")

    rounds = Enum.map(rounds, &get_round(&1, participants))

    %{
      key: key,
      name: name,
      rounds: rounds,
      # participants: participants
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
      # |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

    challonge_matches =
      File.read!("priv/tournments/nv2022c12bm3/round-robin/matches.json")
      |> Jason.decode!()

    round_participants = map_participants_to_challonge_participants(participants, challonge_participants)

    round_participants_by_challonge_id =
      round_participants
      |> Enum.map(& {&1.challonge_id, &1})
      |> Enum.into(%{})
      # |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

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

defmodule N1gp.Spreadsheet do
  def get_participants(folder) do
    html = File.read!("priv/tournments/#{folder}/info.html")

    {:ok, document} = Floki.parse_document(html)

    Floki.find(document, "tr")
    |> Enum.map(&N1gp.Spreadsheet.parse_tr(&1, folder))
    |> Enum.reject(& &1 == nil)
    # |> Enum.filter(& &1.name == "KayThree" || &1.name == "Thiago")
  end

  def parse_tr(tr, folder) do
    tr
    |> Floki.find("td")
    |> Enum.map(&Floki.text/1)
    |> Enum.take(4)
    |> case do
      [str_entrant_no, discord_name, name, version] ->
        case Integer.parse(str_entrant_no) do
          {entrant_no, _rest} ->
            %{
              entrant_no: entrant_no,
              discord_name: discord_name,
              name: name,
              version: version,
              setup: get_setup(folder, entrant_no)
            }

          _ ->
            nil
        end

      _ ->
        nil
    end
  end

  def get_setup(folder, entrant_no) do
    html = File.read!("priv/tournments/#{folder}/#{entrant_no}.html")

    {:ok, document} = Floki.parse_document(html)
    setup_trs = Floki.find(document, "tr")

    %{
      folder:
        setup_trs
        |> Enum.map(&parse_chip_from_setup_tr/1)
        |> Enum.reject(& &1 == nil),
      navicust:
        setup_trs
        |> Enum.map(&parse_navicust_from_setup_tr/1)
        |> Enum.reject(& &1 == nil),
      navicust_image: get_navicust_image(setup_trs)
    }
  end

  def parse_navicust_from_setup_tr(tr) do
    tr
    |> Floki.find("td")
    |> Enum.map(fn node ->
      case Floki.find(node, "a") do
        [] ->
          Floki.text(node)

        a ->
          a
          |> Floki.attribute("href")
          |> List.first()
      end
    end)
    |> Enum.drop(4)
    |> Enum.take(2)
    |> case do
      ["", ""] ->
        nil

      ["Program Name", "Link"] ->
        nil

      [program_name, description] ->
        %{
          program_name: program_name,
          description: description
        }

      _ ->
        nil
    end
  end

  def parse_chip_from_setup_tr(tr) do
    tr
    |> Floki.find("td")
    |> Enum.map(&Floki.text/1)
    |> Enum.take(4)
    |> case do
      [quantity, chip_name, code, reg_tag] ->
        case Integer.parse(quantity) do
          {quantity, _rest} ->
            %{
              quantity: quantity,
              chip_name: chip_name,
              code: code,
              reg_tag: reg_tag
            }

          _ ->
            nil
        end

      _ ->
        nil
    end
  end

  def get_navicust_image(trs) do
    trs
    |> Floki.find("img")
    |> Enum.reverse()
    |> Enum.take(1)
    |> Enum.map(&Floki.attribute(&1, "src"))
    # |> List.first()
    |> case do
      [[image]] ->
        image

      _ ->
        nil
    end
  end
end

# N1gp.Spreadsheet.get_participants("nv2022c12bm3")
# |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
# |> Jason.encode!()
# |> IO.puts

N1gp.Importer.import(
  key: "nv2022c12bm3",
  name: "Blood Moon 2022 #3",
  rounds: [
    %{
      # name: "NEW MOON 2022 Cycle 12: BLOOD MOON #3 ROUND ROBIN",
      # type: "round_robin",
      challonge_id: "bv129coy"
    },
    # TODO: top_cut
  ]
)
|> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
