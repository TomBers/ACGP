defmodule GameState do
  def base_state(channel) do
    %{active_user: nil, scores: %{}, answered: [], winner: nil, channel_id: channel}
  end

  def initial_state(user_states, game_state, channel_id) do
    server = StateAgent.get_server(channel_id)

    new_state = Map.merge(base_state(channel_id), game_state)

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

  def set_field(state, field, value) do
    put_in(state, [field], value)
  end

  def add_answered(state, new_answered) do
    update_in(state, [:answered], &insert_into(&1, new_answered))
  end

  def insert_into(existing, new) do
    if Enum.any?(existing, fn %{name: name} -> name == new.name end) do
      insert_existing(existing, new)
    else
      insert_new(existing, new)
    end
  end

  defp insert_new(existing, new) do
    [new | existing]
  end

  defp insert_existing(existing, new) do
    indx = Enum.find_index(existing, fn ele -> ele.name == new.name end)

    existing
    |> List.update_at(indx, fn elem ->
      Map.update(elem, :answered, elem.answered, fn _existing_val -> new.answered end)
    end)
  end

  defp set_controller(state, user) do
    set_field(state, :active_user, user)
  end

  def reset_state(game_base_state, channel) do
    Map.merge(game_base_state.(nil), base_state(channel))
  end

  def handle_change_in_users(socket, users, sync_fn) do
    gs = socket.assigns.game_state

    if !Enum.any?(users, fn user -> user.name == gs.active_user end) do
      sync_fn.(socket, set_controller(gs, List.first(users).name))
    end
  end

  def check_winner(state, users, channel, win_condition, game_base_state) do
    {is_winner, winner} = win_condition.(state, users)

    if is_winner do
      reset_state(game_base_state, channel)
      |> put_in([:active_user], winner)
      |> put_in([:scores], Map.update(state.scores, winner, 1, fn val -> val + 1 end))
    else
      state
    end
  end


  def get_active_user(state, users) do
    Enum.find(users, fn usr -> usr.name == state.active_user end)
  end

end
