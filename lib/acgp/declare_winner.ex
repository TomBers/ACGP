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

    new_state =
      Map.merge(GameState.base_state(), DrawIt.gen_questions())
      |> put_in([:active_user], gs.winner)
      |> put_in([:scores], Map.update(gs.scores, gs.winner, 1, fn val -> val + 1 end))
  end

  def find_score(game_state, user) do
    Map.get(game_state.scores, user, 0)
  end
end
