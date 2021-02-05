defmodule AcgpWeb.PageController do
  use AcgpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def askhole(conn, _params) do
    instructions = "Based on the game askhole.io Filled with inappropriate, deeply controversial, philosophical, and vulnerable inquiries, this deck of unusual questions will keep your night full of nervous laughter and your relationships somewhat distressing.Filled with inappropriate, deeply controversial, philosophical, and vulnerable inquiries, this deck of unusual questions will keep your night full of nervous laughter and your relationships somewhat distressing."
    render(conn, "tmp.html", game: "Askhole", path: "askhole", instructions: instructions, players: 2)
  end

  def mml(conn, _params) do
    instructions = "Make me laugh is a game to amuse or traumatise your friends. The funniest answer wins."
    render(conn, "tmp.html", game: "Make me laugh", path: "mml", instructions: instructions, players: 3)
  end

  def drawit(conn, _params) do
    instructions = "One person draws, the others guess. The closest one wins."
    render(conn, "tmp.html", game: "Draw It", path: "drawit", instructions: instructions, players: 2)
  end

  def answerwrong(conn, _params) do
    instructions = "A quiz to find the most compelling answer"
    render(conn, "tmp.html", game: "Answer Wrong", path: "aw", instructions: instructions, players: 3)
  end

  def whatthename(conn, _params) do
    instructions = "Name the categories starting with the letter. But be quick; you lose points for the same answers as your friends."
    render(conn, "tmp.html", game: "What the name?", path: "wtn", instructions: instructions, players: 3)
  end

  def picit(conn, _params) do
    instructions = "A game to visualise concepts. You are given an emotion and have to find an image that best represents it.  The player who is judging chooses the winner."
    render(conn, "tmp.html", game: "Picture It", path: "picit", instructions: instructions, players: 3)
  end

  def abundance(conn, _params) do
    instructions = "Challenge your friends to make the most abundant life"
    render(conn, "tmp.html", game: "Abundance", path: "abundance", instructions: instructions, players: 1 )
  end

  def aframe(conn, _params) do
    render conn, "aframe.html", boxes: gen_boxes(50), layout: {AcgpWeb.LayoutView, "aframe.html"}
  end



  def gen_boxes(n) do
  1..n |> Enum.map(fn(b) -> %{id: "b#{b}", pos: "#{rand_in_range} #{rand_in_range} -5", img: get_img()} end)
  end

  def rand_in_range do
    Enum.random([-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8])
  end

  def get_img do
    Enum.random(["boxTexture", "boxTexture2", "boxTexture3"])
  end

end
