defmodule AcgpWeb.PageController do
  use AcgpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def askhole(conn, _params) do
    render(conn, "tmp.html", game: "Askhole", path: "askhole")
  end

  def mml(conn, _params) do
    render(conn, "tmp.html", game: "Make me laugh", path: "mml")
  end

  def drawit(conn, _params) do
    render(conn, "tmp.html", game: "Draw It", path: "drawit")
  end

  def answerwrong(conn, _params) do
    render(conn, "tmp.html", game: "Answer Wrong", path: "aw")
  end

  def whatthename(conn, _params) do
    render(conn, "tmp.html", game: "What the name?", path: "wtn")
  end

  def abundance(conn, _params) do
    render(conn, "tmp.html", game: "Abundance", path: "#")
  end
end
