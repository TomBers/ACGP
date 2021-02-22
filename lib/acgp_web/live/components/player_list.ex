defmodule AcgpWeb.PlayerList do
  use AcgpWeb, :live_component

  alias AcgpWeb.Presence


  def handle_event("change_name", %{"key" => key, "value" => value, "user" => user}, socket) do
    if key == "Enter" do
      Presence.update_presence(self(), socket.assigns.channel_id, user, %{display_name: value})
      {:noreply, socket}
    end
    {:noreply, socket}
  end

  def get_display_name(user) do
    Map.get(user, :display_name, user.name)
  end

end

