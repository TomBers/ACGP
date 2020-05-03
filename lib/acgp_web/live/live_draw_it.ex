defmodule AcgpWeb.LiveDrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "room:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    prefix = GameUtils.get_name()
    uid = GameUtils.get_id()

    name = "#{prefix}_#{uid}"

    Presence.track_presence(
      self(),
      topic(room),
      name,
      %{
        name: name,
        score: 0,
        is_card_czar: false,
      }
    )

    AcgpWeb.Endpoint.subscribe(topic(room))


    {:ok,
      assign(socket,
        room: room,
        img: "",
        my_name: name,
        users: Presence.list_presences(topic(room)) )}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_event("drawit", img, socket) do
    svg = '<svg height="100" width="100"><circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" /></svg>'
    {:noreply, socket |> assign(img: svg)}
  end

end
