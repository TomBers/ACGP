defmodule StateManagement do

  alias AcgpWeb.Presence

  def setup_initial_state(channel_id, room) do
    prefix = GameUtils.get_name()
    uid = GameUtils.get_id()

    name = "#{prefix}_#{uid}"

    is_active = Presence.list_presences(channel_id)
                |> Enum.filter(fn (user) -> user.is_active end)
                |> Enum.empty?

    Presence.track_presence(
      self(),
      channel_id,
      name,
      %{
        name: name,
        score: 0,
        is_active: is_active,
      }
    )
    to_draw = if is_active do
      DrawIt.draw_what()
    else
      ""
    end
    AcgpWeb.Endpoint.subscribe(channel_id)
    %{
      room: room,
      img: "",
      to_draw: to_draw,
      my_name: name,
      users: Presence.list_presences(channel_id)
    }
  end

  def update_is_active(pid, channel_id, name, is_active) do
    Presence.update_presence(pid, channel_id, name, %{name: name, is_active: is_active})
  end

end
