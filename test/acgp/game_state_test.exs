defmodule AcgpWeb.GameStateTest do
  use AcgpWeb.ConnCase

  alias GameState

  @user "A_USER_NAME"

  test "base state" do
    channel_id = "A_NAME:44"
    assert GameState.base_state(channel_id) == %{active_user: nil, answered: [], channel_id: channel_id, scores: %{}, winner: nil}
  end

  # DRAW_IT

  test "Draw It - new value with add_answered" do
    game_state = DrawIt.game_state(@user)
    n_gs = GameState.add_answered(game_state, %{name: @user, any_random_key: "ITS A GUESS"})
    assert n_gs  == %{active_user: "A_USER_NAME", answer: n_gs.answer, answered: [%{any_random_key: "ITS A GUESS", name: "A_USER_NAME"}], img: "", possible_answers: n_gs.possible_answers}
  end

  test "Draw It - existing value with add_answered" do
    game_state = DrawIt.game_state(@user)
    n_gs = GameState.add_answered(game_state, %{name: @user, guess: "ITS A GUESS"})

    assert GameState.add_answered(n_gs, %{name: @user, guess: "2nd Guess"})  == %{active_user: "A_USER_NAME", answer: n_gs.answer, answered: [%{guess: "2nd Guess", name: "A_USER_NAME"}], img: "", possible_answers: n_gs.possible_answers}
  end

  # Abundance

  test "Abundance - new value with add_answered" do
    game_state = Abundance.game_state(@user)
    n_gs = GameState.add_answered(game_state, %{name: @user, cells: [0,1,0,1], score: 22})
    assert n_gs  == %{active_user: nil, winner: nil, answered: [%{name: @user, cells: [0,1,0,1], score: 22}]}
  end

  test "Abundance - existing value with add_answered" do
    game_state = Abundance.game_state(@user)
    n_gs = GameState.add_answered(game_state, %{name: @user, cells: [0,1,0,1], score: 22})

    assert GameState.add_answered(n_gs, %{name: @user, cells: [1,1,1,1], score: 44})  == %{active_user: nil, winner: nil, answered: [%{name: @user, cells: [1,1,1,1], score: 44}]}
  end


end
