defmodule AcgpWeb.LiveAbundance do

  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "abundance:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    channel_id = topic(room)
    params = setup_specific_params(%{})
    {:ok, socket |> assign(params)}
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
    |> Map.put(:params, params)
  end

end
