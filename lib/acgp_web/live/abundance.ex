defmodule AcgpWeb.Abundance do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    params = StateManagement.setup(topic(room), &Abundance.game_state/1, connected?(socket))
    {:ok, socket |> assign(params)}
  end

  def sync_state(socket, new_state) do
    pid = self()
    GameState.update_state(new_state, socket.assigns.channel_id)
    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{state: new_state})
    {:noreply, socket |> assign(game_state: new_state)}
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users = Presence.list_presences(socket.assigns.channel_id)
    GameState.handle_change_in_users(socket, users, &sync_state/2)
    {:noreply, socket |> assign(users: users)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_event("updateCells", cells, socket) do
    name = socket.assigns.my_name
    score = Enum.sum(cells)

    new_state =
          GameState.add_answered(socket.assigns.game_state, %{name: name, cells: cells, score: score})
    sync_state(socket, new_state)
  end

  def get_coverage(game_state, user) do
    Enum.find(game_state.answered, %{score: 0} ,fn(ans) -> ans.name == user.name end).score
  end

  def get_cells(game_state, user) do
    Enum.find(game_state.answered, %{cells: []} ,fn(ans) -> ans.name == user.name end).cells
  end


end
