defmodule AcgpWeb.TestState do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "tst:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)
    {:ok, socket |> assign(setup_specific_params(channel_id, general_params))}
  end

  def setup_specific_params(channel_id, general_params) do
    general_params |> GameState.add_state()
  end

  def sync_state(socket, new_state) do
    pid = self()
    channel_id = topic(socket.assigns.room)

    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "sync_state", %{
      state: new_state
    })

    {:noreply, socket |> assign(game_state: new_state)}
  end

  def handle_event("clear_state", _params, socket) do
    sync_state(socket, GameState.base_state())
  end

  def handle_event("take_control", %{"user" => user}, socket) do
    sync_state(socket, GameState.set_controller(socket.assigns.game_state, user))
  end

  def handle_event("guess", %{"user" => user}, socket) do
    sync_state(
      socket,
      GameState.add_answered(socket.assigns.game_state, %{user: user, guess: "GUESS"})
      |> GameState.check_winner(socket.assigns.users, &win_condition/2)
    )
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def win_condition(state, users) do
    length(state.answered) == length(users)
  end
end
