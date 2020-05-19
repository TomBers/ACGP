defmodule AcgpWeb.LiveAbundance do

  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    general_params = StateManagement.setup_initial_state(topic(room), room)
    num_users = length(general_params.users)
    {:ok, socket |> assign(Map.merge(general_params, %{cells: gen_cells(), player_index: num_users}))}
  end


  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_snapshots", payload: %{cells: cells}}, socket) do
    {:noreply, socket |> assign(cells: cells)}
  end

  def handle_event("updateCells", snapshot, socket) do
    pid = self()
    channel_id = topic(socket.assigns.room)
    name = socket.assigns.my_name

    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "update_snapshots", %{cells: snapshot})
    {:noreply, socket}
  end

  def gen_cells() do
    1..100 |> Enum.map(fn(_x) -> Enum.random([0]) end)
  end

end
