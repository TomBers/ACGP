defmodule StateManagement do

  alias AcgpWeb.Presence

  def setup_initial_state(channel_id, room) do
    prefix = GameUtils.get_name()
    uid = GameUtils.get_id()

    name = "#{prefix}_#{uid}"

    Presence.track_presence(
      self(),
      channel_id,
      name,
      %{
        name: name,
        score: 0,
        is_active: is_user_active(channel_id, name),
      }
    )

    AcgpWeb.Endpoint.subscribe(channel_id)
    %{
      room: room,
      my_name: name,
      users: Presence.list_presences(channel_id)
    }
  end

  def is_user_active(channel_id, user) do
    Presence.list_presences(channel_id)
    |> Enum.filter(fn (user) -> user.is_active end)
    |> Enum.empty?
  end

  def increase_score(pid, channel_id, winner, params) do
    # Only increase score if I am the winner
    if winner == params.my_name do
      update_my_presence(pid, channel_id, params.my_name, true, get_my_score(params.my_name, params.users) + 1)
    end
  end

  def get_my_score(name, users) do
    params =
      users
      |> Enum.find(%{score: 0}, fn(usr) -> usr.name == name end)

    params.score
  end

  def update_my_presence(pid, channel_id, name, is_active, score \\ 0 ) do
    Presence.update_presence(pid, channel_id, name, %{name: name, is_active: is_active, score: score})
  end

end
