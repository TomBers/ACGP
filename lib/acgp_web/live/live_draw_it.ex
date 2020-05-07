defmodule AcgpWeb.LiveDrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "drawit:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)

    {:ok, socket |> assign(setup_specific_params(channel_id, general_params))}
  end

  def setup_specific_params(channel_id, general_params) do
    to_draw =
        case StateManagement.is_user_active(general_params.my_name, general_params.users) do
          true -> DrawIt.draw_what()
          false -> ""
    end
    general_params
      |> Map.put(:img, "")
      |> Map.put(:to_draw, to_draw)
  end

  #  Events from Page

  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "update_image", %{img: img})
    {:noreply, socket}
  end

  def handle_event("letmedraw", %{"user" => user}, socket) do
    channel_id = topic(socket.assigns.room)
    name = socket.assigns.my_name
    pid = self()

    StateManagement.update_my_presence(pid, channel_id, name, true)
    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "change_is_active", %{user: user})
    {:noreply, socket |> assign(img: "", to_draw: DrawIt.draw_what())}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    {:noreply, socket |> assign(img: img)}
  end

  def handle_info(%{event: "change_is_active", payload: %{ user: user}}, socket) do
    StateManagement.update_my_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, false)
    {:noreply, socket |> assign(img: "")}
  end

  def am_I_draw_king(my_name, users) do
    StateManagement.is_user_active(my_name, users)
  end

end
