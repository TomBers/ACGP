defmodule AcgpWeb.LiveAbundance do

  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)
    {:ok, socket |> assign(setup_specific_params(general_params))}
  end

  def setup_specific_params(general_params) do
    width = 100
    height = 100
    cellSize = 10
    scale = 5
    params = %{
      width: width,
      height: height,
      cellSize: cellSize,
      scale: scale,
      numXCells: div(width, cellSize),
      numYCells: div(height, cellSize)
    }
    general_params
    |> Map.put(:cells, generate_cells(width, height))
    |> Map.put(:params, params)
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def generate_cells(w, h) do
    tot = w * h
    1..tot
    |> Enum.map(fn(_x) -> Enum.random([0,1]) end)
  end

  def calc_x_pos(indx, params) do
    x = rem(indx, params.numXCells)
    x * params.cellSize * params.scale
  end

  def calc_y_pos(indx, params) do
    y = div(indx, params.numYCells);
    y * params.cellSize * params.scale
  end

  def handle_event("click", %{"pageX" => pageX, "pageY" => pageY, "x" => x, "y" => y}, socket) do
    gx = x - pageX
    gy = y - pageY - 1
    multiplier = socket.assigns.params.cellSize * socket.assigns.params.scale
    cells = socket.assigns.cells

    indx = div(x, multiplier) + (10 * div(y, multiplier))
    current = Enum.at(cells, indx)
    new_cells = List.replace_at(cells, indx, invert(current))
    {:noreply, socket |> assign(:cells, new_cells)}
  end

  def invert(val) when val == 0 do
    1
  end

  def invert(val) when val == 1 do
    0
  end

end
