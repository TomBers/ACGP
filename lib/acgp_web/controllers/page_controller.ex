defmodule AcgpWeb.PageController do
  use AcgpWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def liveroom(conn, %{"id" => id}) do
    live_render(conn, AcgpWeb.LiveRoom, session: %{"id" => id})
  end
end
