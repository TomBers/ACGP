defmodule AcgpWeb.Abundance do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    params = StateManagement.setup(topic(room), &Abundance.game_state/1, connected?(socket))
    {:ok, socket |> assign(params)}
  end

  # def send_tick() do
  #   Process.send_after(self(), :tick, 1000)
  # end

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


  def handle_info(%{event: "update_snapshots", payload: %{cells: cells}}, socket) do
    IO.inspect(cells)
    {:noreply, socket}
  end

  def handle_event("updateCells", snapshot, socket) do
    IO.inspect(snapshot)
    {:noreply, socket}
  end


end
