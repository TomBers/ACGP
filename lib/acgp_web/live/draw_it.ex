defmodule AcgpWeb.DrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "drawit:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    params = StateManagement.setup(topic(room), &DrawIt.game_state/1, connected?(socket))
    {:ok, socket |> assign(params)}
  end

  def win_condition(state, users) do
    if length(state.answered) == length(users) - 1 do
      {true, who_won(state, users)}
    else
      {false, nil}
    end
  end

  def who_won(state, users) do
    Enum.find(state.answered, GameState.get_active_user(state, users), fn ans ->
      ans.guess == state.answer
    end).name
  end

  def sync_state(socket, new_state) do
    pid = self()
    GameState.update_state(new_state, socket.assigns.channel_id)
    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{state: new_state})
    {:noreply, socket |> assign(game_state: new_state)}
  end

  #  Events from Page

  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), socket.assigns.channel_id, "update_image", %{img: img})
    {:noreply, socket}
  end

  def handle_event("guess", %{"user" => user, "answer" => answer}, socket) do
    new_state =
      GameState.add_answered(socket.assigns.game_state, %{name: user, guess: answer})
      |> GameState.check_winner(socket.assigns.users, &win_condition/2, &DrawIt.game_state/1)

    sync_state(socket, new_state)
  end
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users = Presence.list_presences(socket.assigns.channel_id)
    GameState.handle_change_in_users(socket, users, &sync_state/2)
    {:noreply, socket |> assign(users: users)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    sync_state(socket, GameState.set_field(socket.assigns.game_state, :img, img))
  end
end
