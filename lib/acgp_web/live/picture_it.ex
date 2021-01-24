defmodule AcgpWeb.PictureIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "picit:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    if connected?(socket) do
      params =
        StateManagement.setup_initial_state(topic(room))
        |> add_specic_state()

      {:ok, socket |> assign(params)}
    else
      {:ok, socket |> assign(empty_game_state())}
    end
  end

  def add_specic_state(params) do
    gs = game_state(params.my_name)
    params |> GameState.initial_state(gs, params.channel_id)
  end

  def game_state(user \\ "") do
    ideas = ["Acceptance", "Amusement", "Anger", "Angst", "Annoying", "Awe", "Boredom", "Confidence", "Contentment", "Courage", "Doubt", "Embarrassment", "Enthusiasm", "Envy", "Euphoria", "Faith", "Fear", "Frustration", "Gratitude", "Greed", "Guilt", "Happiness", "Hatred", "Hope", "Horror", "Hostility", "Humiliation", "Interest", "Jealousy", "Joy", "Kindness", "Loneliness", "Love", "Lust", "Nostalgia", "Outrage", "Panic", "Passion", "Pity", "Pleasure", "Pride", "Rage", "Regret", "Rejection", "Remorse", "Resentment", "Sadness"]

    %{
      active_user: user,
      idea: Enum.random(ideas),
      images: [],
      answered: [],
      winner: nil
    }
  end

  def empty_game_state do
    %{
      game_state: %{
        active_user: nil,
        idea: "",
        images: [],
        answered: [],
        score: nil,
        winner: nil
      },
      my_name: "",
      users: []
    }
  end

  def win_condition(state, _users) do
    {true, state.winner}
  end

  def sync_state(socket, new_state) do
    pid = self()

    GameState.update_state(new_state, socket.assigns.channel_id)

    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{
      state: new_state
    })

    {:noreply, socket |> assign(game_state: new_state)}
  end

  #  Events from Page

  def handle_event("selectImage", %{"url" => url}, socket) do
    name = socket.assigns.my_name
    new_state =
          GameState.add_answered(socket.assigns.game_state, %{name: name, url: url})

    IO.inspect(new_state)
    sync_state(socket, new_state)
  end

  def handle_event("chooseWinningImage", %{"user" => user}, socket) do
    gs = GameState.set_field(socket.assigns.game_state, :winner, user)

    sync_state(
      socket,
      GameState.check_winner(
        gs,
        socket.assigns.users,
        &win_condition/2,
        &game_state/0
      )
    )
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users = Presence.list_presences(socket.assigns.channel_id)
    GameState.handle_change_in_users(socket, users, &sync_state/2)
    {:noreply, socket |> assign(users: users)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end
end
