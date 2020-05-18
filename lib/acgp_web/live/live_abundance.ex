defmodule AcgpWeb.LiveAbundance do

  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    channel_id = topic(room)
    prefix = GameUtils.get_name()
    uid = GameUtils.get_id()
    name = "#{prefix}_#{uid}"

    AcgpWeb.Endpoint.subscribe(channel_id)
    {:ok, socket |> assign(%{my_name: name, room: room, cells: gen_cells()})}
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
