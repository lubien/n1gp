defmodule N1gp.Repo do
  use Ecto.Repo,
    otp_app: :n1gp,
    adapter: Ecto.Adapters.Postgres
end
