defmodule DeclareWinner do
  alias AcgpWeb.DrawIt
  alias GameState

  def run do
    gs = %{
      active_user: "Hammer_494",
      answered: [%{guess: "Homely karate", user: "Writing_315"}],
      img: "",
      possible_answers: [
        "Magnificent vegetable",
        "Scrawny jar",
        "Murky window",
        "Homely karate",
        "Broad letter"
      ],
      scores: %{"Hammer_494" => 2, "Writing_315" => 4},
      to_draw: "Broad letter",
      winner: "Hammer_494"
    }

    winner = gs.winner
    scores = gs.scores

    # %{^winner => score} =
    #   Enum.find(scores, %{winner => 0}, fn {name => _score} -> name == winner end)

    scores = Map.update(scores, winner, 1, fn val -> val + 1 end)

    new_state =
      Map.merge(GameState.base_state(), DrawIt.gen_questions())
      |> put_in([:active_user], winner)
      |> put_in([:scores], scores)
  end

  def find_score(game_state, user) do
    u = Map.get(game_state.scores, user, 0)
    IO.inspect(u)
  end
end
