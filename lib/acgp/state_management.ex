defmodule StateManagement do
  alias AcgpWeb.Presence

  def setup_initial_state(channel_id, extra_presence_params \\ %{}) do
    prefix = GameUtils.get_name()
    uid = GameUtils.get_id()

    name = "#{prefix}_#{uid}"

    presence_params =
      Map.merge(
        %{
          name: name
        },
        extra_presence_params
      )

    Presence.track_presence(
      self(),
      channel_id,
      name,
      presence_params
    )

    AcgpWeb.Endpoint.subscribe(channel_id)

    %{
      channel_id: channel_id,
      my_name: name,
      users: Presence.list_presences(channel_id)
    }
  end

  defp are_there_no_active_users(channel_id, user) do
    Presence.list_presences(channel_id)
    |> Enum.filter(fn user -> user.is_active end)
    |> Enum.empty?()
  end

  def increase_score(pid, channel_id, winner, params) do
    if winner == params.my_name do
      update_my_presence(
        pid,
        channel_id,
        winner,
        true,
        get_my_score(winner, params.users, true)
      )
    end
  end

  def get_my_score(name, users, incr) do
    params =
      users
      |> Enum.find(%{score: 0}, fn usr -> usr.name == name end)

    if incr do
      params.score + 1
    else
      params.score
    end
  end

  def change_user_and_maybe_inc_score(pid, channel_id, params, i_won) do
    my_name = params.my_name

    update_my_presence(
      pid,
      channel_id,
      my_name,
      i_won,
      get_my_score(my_name, params.users, i_won)
    )
  end

  def update_my_presence(pid, channel_id, name, is_active, score \\ 0) do
    Presence.update_presence(pid, channel_id, name, %{
      name: name,
      is_active: is_active,
      score: score
    })
  end

  def active_user(users) do
    users
    |> Enum.find(fn usr -> usr.is_active == true end)
  end

  def is_user_active(my_name, users) do
    ur =
      users
      |> Enum.find(%{is_active: false}, fn usr -> usr.name == my_name end)

    ur.is_active
  end
end
