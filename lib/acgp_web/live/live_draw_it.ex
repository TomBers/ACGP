defmodule AcgpWeb.LiveDrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "room:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    prefix = GameUtils.get_name()
    uid = GameUtils.get_id()

    name = "#{prefix}_#{uid}"

    draw_king = Presence.list_presences(topic(room)) |> Enum.filter(fn(user) -> user.is_draw_king end) |> Enum.empty?

    Presence.track_presence(
      self(),
      topic(room),
      name,
      %{
        name: name,
        score: 0,
        is_draw_king: draw_king,
      }
    )
    to_draw = if draw_king do
      DrawIt.draw_what()
      else
      ""
    end
    AcgpWeb.Endpoint.subscribe(topic(room))

    {:ok,
      assign(socket,
        room: room,
        img: "",
        to_draw: to_draw,
        my_name: name,
        users: Presence.list_presences(topic(room))  )}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    {:noreply, socket |> assign(img: img)}
  end

  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "update_image", %{img: img})
    {:noreply, socket |> assign(img: img)}
  end

  def handle_event("letmedraw", %{"user" => user}, socket) do
    Presence.update_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, %{name: socket.assigns.my_name, is_draw_king: true})
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "change_draw_king", %{user: user})
    {:noreply, socket |> assign(img: "", to_draw: DrawIt.draw_what())}
  end

  def handle_info(%{event: "change_draw_king", payload: %{user: user}}, socket) do
    Presence.update_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, %{name: socket.assigns.my_name, is_draw_king: false})
    {:noreply, socket |> assign(img: "")}
  end


  def am_I_draw_king(my_name, users) do
    ur = users |> Enum.filter(fn(usr) -> usr.name == my_name end) |> List.first
    ur.is_draw_king
  end

end
