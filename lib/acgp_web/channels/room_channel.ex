defmodule AcgpWeb.RoomChannel do
  use Phoenix.Channel

  def join(_topic, _message, socket) do
    {:ok, socket}
  end

  def handle_in("peer-message", %{"body" => body}, socket) do
    broadcast_from!(socket, "peer-message", %{body: body})
    {:noreply, socket}
  end

end
