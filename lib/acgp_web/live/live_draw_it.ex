defmodule AcgpWeb.LiveDrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "drawit:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    params = StateManagement.setup_initial_state(topic(room), room)
    {:ok, socket |> assign(params)}
  end

#  Events from Page

  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "update_image", %{img: img})
    {:noreply, socket }
  end

  def handle_event("letmedraw", %{"user" => user}, socket) do
    channel_id = topic(socket.assigns.room)
    name = socket.assigns.my_name
    pid = self()

    StateManagement.update_is_active(pid, channel_id, name, true)
    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "change_is_active", %{user: user})
    {:noreply, socket |> assign(img: "", to_draw: DrawIt.draw_what())}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    {:noreply, socket |> assign(img: img)}
  end

  def handle_info(%{event: "change_is_active", payload: %{user: user}}, socket) do
    StateManagement.update_is_active(self(), topic(socket.assigns.room), socket.assigns.my_name, false)
    {:noreply, socket |> assign(img: "")}
  end

  def am_I_draw_king(my_name, users) do
    ur = users |> Enum.filter(fn(usr) -> usr.name == my_name end) |> List.first
    ur.is_active
  end

end
