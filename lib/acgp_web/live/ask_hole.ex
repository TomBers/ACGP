defmodule AcgpWeb.AskHole do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "askhole:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    params = StateManagement.setup(topic(room), &AskHole.game_state/1, connected?(socket))
    {:ok, socket |> assign(params)}
  end


  def sync_state(socket, new_state) do
    pid = self()
    GameState.update_state(new_state, socket.assigns.channel_id)
    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{
      state: new_state
    })
    {:noreply, socket |> assign(game_state: new_state)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(socket.assigns.channel_id))}
  end

  def handle_info(%{event: "connect_state", payload: %{connected: connected}}, socket) do
    {:noreply, assign(socket, connected: connected)}
  end

  def handle_event("new_card", _params, socket) do
    socket |> sync_state(GameState.set_field(socket.assigns.game_state, :question, AskHole.get_question()))
  end

  def handle_event("changeConnection", _state, socket) do
    gs = socket.assigns.game_state
    new_connection_state = !gs.connected

    ns = GameState.set_field(gs, :connected, new_connection_state)
    sync_state(socket, ns)
  end
end
