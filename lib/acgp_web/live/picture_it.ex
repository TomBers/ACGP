defmodule AcgpWeb.PictureIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "picit:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    params = StateManagement.setup(topic(room), &PicIt.game_state/1, connected?(socket))
    {:ok, socket |> assign(params)}
  end

  def win_condition(state, _users) do
    {true, state.winner}
  end

  def sync_state(socket, new_state) do
    pid = self()
    GameState.update_state(new_state, socket.assigns.channel_id)
    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{state: new_state})
    {:noreply, socket |> assign(game_state: new_state)}
  end

  #  Events from Page

  def handle_event("selectImage", %{"url" => url}, socket) do
    name = socket.assigns.my_name
    new_state =
          GameState.add_answered(socket.assigns.game_state, %{name: name, url: url})

    sync_state(socket, new_state)
  end

  def handle_event("chooseWinningImage", %{"user" => user}, socket) do
    gs = GameState.set_field(socket.assigns.game_state, :winner, user)

    sync_state(
      socket,
      GameState.check_winner(
        gs,
        socket.assigns.users,
        &win_condition/2,
        &PicIt.game_state/1
      )
    )
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users = Presence.list_presences(socket.assigns.channel_id)
    GameState.handle_change_in_users(socket, users, &sync_state/2)
    {:noreply, socket |> assign(users: users)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end
end
