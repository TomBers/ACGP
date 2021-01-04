defmodule AcgpWeb.LiveAbundance do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    general_params = StateManagement.setup_initial_state(topic(room), room)
    send_tick()
    {:ok, socket |> assign(setup_state_server(room, general_params))}
  end

  def send_tick() do
    Process.send_after(self(), :tick, 1000)
  end

  def setup_state_server(room, general_params) do
    num_users = length(general_params.users)
    server = StateAgent.get_server(room)
    cells = StateAgent.get_or_generate(server, :state, gen_cells())

    general_params
    |> Map.put(:server, server)
    |> Map.put(:cells, cells)
    |> Map.put(:player_index, num_users)
  end

  def handle_info(:tick, socket) do
    channel_id = topic(socket.assigns.room)
    server = socket.assigns.server
    cells = StateAgent.get(server, :state)
    AcgpWeb.Endpoint.broadcast(channel_id, "update_snapshots", %{cells: cells})
    send_tick()
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_snapshots", payload: %{cells: cells}}, socket) do
    {:noreply, socket |> assign(cells: cells)}
  end

  def handle_event("updateCells", snapshot, socket) do
    resolve_state(socket, snapshot)
    {:noreply, socket}
  end

  def resolve_state(socket, new_state) do
    channel_id = topic(socket.assigns.room)
    server = socket.assigns.server
    old_state = StateAgent.get(server, :state)

    resolved_state =
      old_state
      |> Enum.with_index()
      |> Enum.map(fn {cell, indx} -> resolve_cell(cell, Enum.at(new_state, indx)) end)

    StateAgent.put(server, :state, resolved_state)
  end

  #  TODO - This could be more complex - how to 'turn off' cells - what takes precedence?
  def resolve_cell(old_val, new_val) when old_val == 0, do: new_val
  #  TODO - not sure why this kept turning off the cells - but I am done for the day
  #  def resolve_cell(old_val, new_val) when old_val != 0 and new_val != 0, do: 0
  def resolve_cell(old_val, new_val), do: old_val

  def gen_cells() do
    1..100 |> Enum.map(fn _x -> Enum.random([0]) end)
  end
end
