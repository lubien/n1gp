defmodule N1gpWeb.PageController do
  use N1gpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
