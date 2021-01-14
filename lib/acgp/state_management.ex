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
end
