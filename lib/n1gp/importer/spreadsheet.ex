defmodule N1gp.Importer.Spreadsheet do
  def get_participants(folder) do
    html =
      Path.join([File.cwd!, "priv/tournments/#{folder}/info.html"])
      |> File.read!()

    {:ok, document} = Floki.parse_document(html)

    Floki.find(document, "tr")
    |> Enum.map(&parse_tr(&1, folder))
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
            Map.merge(%{
              entrant_no: entrant_no,
              discord_name: discord_name,
              name: name,
              version: version,
            }, get_setup(folder, entrant_no))

          _ ->
            nil
        end

      _ ->
        nil
    end
  end

  def get_setup(folder, entrant_no) do
    html =
      Path.join([File.cwd!, "priv/tournments/#{folder}/#{entrant_no}.html"])
      |> File.read!()

    {:ok, document} = Floki.parse_document(html)
    setup_trs = Floki.find(document, "tr")

    %{
      # folder:
      #   setup_trs
      #   |> Enum.map(&parse_chip_from_setup_tr/1)
      #   |> Enum.reject(& &1 == nil),
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
