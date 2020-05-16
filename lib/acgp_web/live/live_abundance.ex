defmodule AcgpWeb.LiveAbundance do

  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    channel_id = topic(room)
    board_params = setup_board_params()
    general_params = StateManagement.setup_initial_state(channel_id, room)
    {:ok, socket |> assign(Map.merge(general_params, board_params))}
  end

  def setup_board_params(general_params \\ %{}) do
    width = 100
    height = 100
    cellSize = 10
    scale = 3
    params = %{
      width: width,
      height: height,
      cellSize: cellSize,
      scale: scale,
      numXCells: div(width, cellSize),
      numYCells: div(height, cellSize)
    }

    general_params
    |> Map.put(:params, params)
    |> Map.put(:snapshots, %{})
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_snapshots", payload: %{user: user, snapshot: snapshot}}, socket) do
    {:noreply, socket |> assign(snapshots: Map.put(socket.assigns.snapshots, user, snapshot))}
  end

  def handle_event("updateCells", snapshot, socket) do
    pid = self()
    channel_id = topic(socket.assigns.room)
    name = socket.assigns.my_name

    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "update_snapshots", %{user: name, snapshot: snapshot})
    {:noreply, socket}
  end

end
