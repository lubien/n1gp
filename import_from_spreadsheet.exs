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

# N1gp.Importer.import_tournment(
#   key: "nv2022c12bm3",
#   name: "Blood Moon 2022 #3",
#   rounds: [
#     %{
#       # name: "NEW MOON 2022 Cycle 12: BLOOD MOON #3 ROUND ROBIN",
#       # type: "round_robin",
#       challonge_id: "bv129coy"
#     },
#     # TODO: top_cut
#   ]
# )

# N1gp.Importer.import_chips()
# # |> Enum.filter(& &1.code == nil)
# |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
