defmodule N1gpWeb.Router do
  use N1gpWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {N1gpWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", N1gpWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/chips", ChipLive.Index, :index
    live "/chips/new", ChipLive.Index, :new
    live "/chips/:id/edit", ChipLive.Index, :edit

    live "/chips/:id", ChipLive.Show, :show
    live "/chips/:id/show/edit", ChipLive.Show, :edit

    live "/tournments", TournmentLive.Index, :index
    live "/tournments/new", TournmentLive.Index, :new
    live "/tournments/:id/edit", TournmentLive.Index, :edit

    live "/tournments/:id", TournmentLive.Show, :show
    live "/tournments/:id/stats", TournmentLive.Show, :stats
    live "/tournments/:id/chips", TournmentLive.Show, :most_used_chips
    live "/tournments/:id/rounds/:round_id", TournmentLive.Show, :show
    live "/tournments/:id/participant/:participant_id", TournmentLive.Show, :participant
    live "/tournments/:id/show/edit", TournmentLive.Show, :edit

    live "/participants", ParticipantLive.Index, :index
    live "/participants/new", ParticipantLive.Index, :new
    live "/participants/:id/edit", ParticipantLive.Index, :edit

    live "/participants/:id", ParticipantLive.Show, :show
    live "/participants/:id/show/edit", ParticipantLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", N1gpWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: N1gpWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
