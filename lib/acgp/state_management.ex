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

  def setup(channel_id, game_state, connected) do
    if connected do
      setup_initial_state(channel_id) |> add_specic_state(game_state)
    else
      empty_game_state(game_state)
    end
  end

  defp add_specic_state(params, game_state) do
    gs = game_state.(params.my_name)
    params |> GameState.initial_state(gs, params.channel_id)
  end

  defp empty_game_state(game_state) do
    %{
      game_state: game_state.(nil),
      my_name: "",
      users: []
    }
  end
end
