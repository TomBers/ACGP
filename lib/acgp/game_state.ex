defmodule GameState do
  def base_state do
    %{active_user: nil, scores: %{}, answered: [], winner: nil}
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

  def set_field(state, field, value) do
    put_in(state, [field], value)
  end

  def add_answered(state, user) do
    update_in(state, [:answered], &[user | &1])
  end

  def set_controller(state, user) do
    set_field(state, :active_user, user)
  end

  def reset_state(game_base_state) do
    Map.merge(game_base_state.(), base_state())
  end

  def check_winner(state, users, win_condition, game_base_state) do
    {is_winner, winner} = win_condition.(state, users)

    if is_winner do
      Map.merge(game_base_state.(), base_state())
      |> set_field(:winner, winner)
      |> set_field(:active_user, winner)
      |> set_field(:answered, [])
    else
      state
    end
  end

  def get_winner(state, users) do
    Enum.find(users, get_active_user(state, users), fn usr -> usr.name == state.winner end)
  end

  def get_active_user(state, users) do
    Enum.find(users, fn usr -> usr.name == state.active_user end)
  end
end
