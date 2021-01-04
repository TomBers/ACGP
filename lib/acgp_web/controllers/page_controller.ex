defmodule AcgpWeb.PageController do
  use AcgpWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def askhole(conn, _params) do
    render(conn, "tmp.html", game: "Askhole", path: "askhole")
  end

  def cah(conn, _params) do
    render(conn, "tmp.html", game: "Cards Against Humanity", path: "cah")
  end

  def drawit(conn, _params) do
    render(conn, "tmp.html", game: "Draw It", path: "drawit")
  end

  def answerwrong(conn, _params) do
    render(conn, "tmp.html", game: "Answer Wrong", path: "aw")
  end

  def abundance(conn, _params) do
    render(conn, "tmp.html", game: "Abundance", path: "#")
  end
end
