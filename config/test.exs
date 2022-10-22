import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :n1gp, N1gp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "n1gp_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :n1gp, N1gpWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "emNj4u1j9VE1qcOZnn0UngaVBWpdZo6JVpmpJ3LCuzvKeBYMBUBkd9BSZD9tUfiI",
  server: false

# In test we don't send emails.
config :n1gp, N1gp.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
