defmodule GameState do
  def base_state do
    %{active_user: nil, scores: %{}, answered: []}
  end

  def add_state(user_states) do
    user_states
    |> Map.put(:game_state, base_state())
  end

  def add_answered(state, user) do
    update_in(state, [:answered], &[user | &1])
  end

  def set_controller(state, user) do
    put_in(state, [:active_user], user)
  end

  def check_winner(state, users, win_condition) do
    if win_condition.(state, users) do
      IO.inspect("We have a winner")
    end

    state
  end
end
