import Ecto.Query

# N1gp.Importer.Spreadsheet.get_participants("nv2022c12bm3")
# |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
# |> Enum.flat_map(& &1.setup.folder)
# |> Enum.dedup_by(& &1.chip_name)
# |> Enum.reject(fn chip ->
#   N1gp.Chips.Chip
#   |> where(name: ^chip.chip_name)
#   |> N1gp.Repo.exists?()
# end)
# |> Jason.encode!()
# |> IO.puts

# N1gp.Tournments.import_tournment(key: "nv2022c12bm3",name: "Blood Moon 2022 #3",type: "blood_moon",
# # N1gp.Importer.import_tournment(key: "nv2022c12bm3",name: "Blood Moon 2022 #3",type: "blood_moon",
#   rounds: [
#     %{challonge_id: "bv129coy"},
#     %{challonge_id: "5almu1d0"},
#   ]
# )

N1gp.Tournments.import_tournment(key: "nv2022c16bm4",name: "Blood Moon 2022 #4",type: "blood_moon",
# N1gp.Importer.import_tournment(key: "nv2022c12bm3",name: "Blood Moon 2022 #3",type: "blood_moon",
  rounds: [
    %{challonge_id: "xzids384"},
    %{challonge_id: "gx8fe5rf"},
  ]
)

# N1gp.Importer.import_chips()
# # |> Enum.filter(& &1.code == nil)
# |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
