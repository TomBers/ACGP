defmodule GameState do
  def base_state do
    %{active_user: nil, scores: %{}, answered: [], winner: nil}
  end

  def initial_state(user_states, game_state, channel_id) do
    # Todo - Set active user if this is a new game
    server = StateAgent.get_server(channel_id)

    new_state = Map.merge(base_state(), game_state)

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

  def clear_state(channel_id) do
    server = StateAgent.get_server(channel_id)
    StateAgent.put(server, :game_state, nil)
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

  def handle_leaving(socket, users, leavers, sync_func) do
    cid = socket.assigns.channel_id

    if length(users) == 0 do
      clear_state(cid)
    else
      gs = socket.assigns.game_state

      if Enum.any?(leavers, fn {name, _val} -> name == gs.active_user end) do
        IO.inspect(users)
        IO.inspect(List.first(users).name)
        ns = set_controller(gs, List.first(users).name)
        IO.inspect(ns)
        sync_func.(socket, ns)
      end
    end
  end

  def check_winner(state, users, win_condition, game_base_state) do
    {is_winner, winner} = win_condition.(state, users)

    if is_winner do
      reset_state(game_base_state)
      |> put_in([:active_user], winner)
      |> put_in([:scores], Map.update(state.scores, winner, 1, fn val -> val + 1 end))
    else
      state
    end
  end

  # TODO this is the win condition for DrawIt - consider moving
  def who_won(state, users) do
    Enum.find(state.answered, get_active_user(state, users), fn ans ->
      ans.guess == state.answer
    end).name
  end

  def get_winner(state, users) do
    Enum.find(users, get_active_user(state, users), fn usr -> usr.name == state.winner end)
  end

  def get_active_user(state, users) do
    Enum.find(users, fn usr -> usr.name == state.active_user end)
  end
end
