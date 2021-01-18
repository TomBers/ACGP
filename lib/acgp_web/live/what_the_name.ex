defmodule AcgpWeb.WhatTheName do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias AcgpWeb.Presence

  @timer_time 50

  defp topic(id), do: "whatthename:#{id}"

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
    letter = WTN.letter()
    categories = WTN.categories(3)

    %{
      active_user: user,
      letter: letter,
      categories: categories,
      users_answered: [],
      answered: [],
      time: @timer_time
    }
  end

  def empty_game_state do
    %{
      game_state: %{
        active_user: nil,
        letter: nil,
        categories: [],
        users_answered: [],
        answered: [],
        time: 0
      },
      my_name: "",
      users: []
    }
  end

  def sync_state(socket, new_state) do
    pid = self()

    GameState.update_state(new_state, socket.assigns.channel_id)

    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{
      state: new_state
    })

    {:noreply, socket |> assign(game_state: new_state)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_info(:tick, socket) do
    gs = socket.assigns.game_state

    new_state =
      if gs.time <= 0 or length(gs.users_answered) == length(socket.assigns.users) do
        gs
        |> put_in([:scores], WTN.calc_scores(gs))
        |> put_in([:letter], WTN.letter())
        |> put_in([:categories], WTN.categories(3))
        |> put_in([:answered], [])
        |> put_in([:time], @timer_time)
        |> put_in([:users_answered], [])
      else
        gs |> put_in([:time], gs.time - 1)
      end

    sync_state(socket, new_state)
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users = Presence.list_presences(socket.assigns.channel_id)

    if length(users) == 2 do
      :timer.send_interval(1000, self(), :tick)
    end

    GameState.handle_change_in_users(socket, users, &sync_state/2)
    {:noreply, socket |> assign(users: users)}
  end

  def handle_event("update_answers", %{"game" => answers}, socket) do
    {my_name, answers} = Map.get_and_update(answers, "my_name", fn _ -> :pop end)

    new_state =
      socket.assigns.game_state
      |> GameState.add_answered(%{name: my_name, answered: answers})

    sync_state(socket, new_state)
  end

  def handle_event("save_answers", %{"game" => answers}, socket) do
    gs = socket.assigns.game_state
    {my_name, _answers} = Map.get_and_update(answers, "my_name", fn _ -> :pop end)
    new_state = gs |> put_in([:users_answered], [my_name | gs.users_answered])
    sync_state(socket, new_state)
  end
end
