defmodule GameState do
  def base_state do
    %{active_user: nil, scores: %{}, answered: []}
  end

  def initial_state(user_states, game_state, channel_id) do
    server = StateAgent.get_server(channel_id)

    new_state = Map.merge(game_state, base_state())

    game_state =
      if StateAgent.get(server, :game_state) do
        StateAgent.get(server, :game_state)
      else
        StateAgent.put(server, :game_state, new_state)
        new_state
      end

    user_states |> Map.put(:game_state, game_state)
  end

  def update_state(new_state, channel_id) do
    server = StateAgent.get_server(channel_id)
    StateAgent.put(server, :game_state, new_state)
  end

  def get_state(channel_id) do
    server = StateAgent.get_server(channel_id)
    StateAgent.get(server, :game_state)
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
