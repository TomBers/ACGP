defmodule AcgpWeb.AskHole do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "askhole:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    if connected?(socket) do
      channel_id = topic(room)

      params =
        StateManagement.setup_initial_state(channel_id)
        |> add_specic_state()

      {:ok, socket |> assign(params)}
    else
      {:ok, socket |> assign(empty_game_state())}
    end
  end

  def add_specic_state(params) do
    params |> GameState.initial_state(%{question: "", connected: false}, params.channel_id)
  end

  def empty_game_state do
    %{
      game_state: %{
        question: "",
        connected: false
      },
      my_name: "",
      users: [],
      channel_id: ""
    }
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

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(socket.assigns.channel_id))}
  end

  def handle_event("new_card", _params, socket) do
    ns = GameState.set_field(socket.assigns.game_state, :question, AskHole.get_question())
    sync_state(socket, ns)
  end

  def handle_info(%{event: "connect_state", payload: %{connected: connected}}, socket) do
    {:noreply, assign(socket, connected: connected)}
  end

  def handle_event("changeConnection", _state, socket) do
    gs = socket.assigns.game_state
    new_connection_state = !gs.connected

    ns = GameState.set_field(gs, :connected, new_connection_state)
    sync_state(socket, ns)
  end
end
