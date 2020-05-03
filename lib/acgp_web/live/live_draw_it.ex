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

    users = Presence.list_presences(topic(room))
    {:ok,
      assign(socket,
        room: room,
        img: "",
        is_draw_king: length(users) == 1,
        my_name: name,
        users: users  )}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    {:noreply, socket |> assign(img: encode_img(img))}
  end


  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "update_image", %{img: img})
    {:noreply, socket}
  end

  def encode_img(img_string) do
    'data:image/svg+xml;base64,#{:base64.encode(img_string)}'
  end

end
