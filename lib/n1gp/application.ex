defmodule N1gp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      N1gp.Repo,
      # Start the Telemetry supervisor
      N1gpWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: N1gp.PubSub},
      # Start the Endpoint (http/https)
      N1gpWeb.Endpoint
      # Start a worker by calling: N1gp.Worker.start_link(arg)
      # {N1gp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: N1gp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    N1gpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
