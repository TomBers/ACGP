defmodule AcgpWeb.PageController do
  use AcgpWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def askhole(conn, %{"id" => id}) do
    live_render(conn, AcgpWeb.LiveAskHole, session: %{"id" => id})
  end

  def cah(conn, %{"id" => id}) do
    live_render(conn, AcgpWeb.LiveCardsAgainstHumanity, session: %{"id" => id})
  end

  def drawit(conn, %{"id" => id}) do
    live_render(conn, AcgpWeb.LiveDrawIt, session: %{"id" => id})
  end

  def abundance(conn, _params) do
    render(conn, "abundance.html")
  end

end
