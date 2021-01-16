defmodule AcgpWeb.WhatTheName do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias AcgpWeb.Presence

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
      answer: nil,
      answered: []
    }
  end

  def empty_game_state do
    %{
      game_state: %{
        active_user: nil,
        letter: nil,
        categories: [],
        answer: nil,
        answered: []
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

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users = Presence.list_presences(socket.assigns.channel_id)
    GameState.handle_change_in_users(socket, users, &sync_state/2)
    {:noreply, socket |> assign(users: users)}
  end

  def handle_event("save_answers", %{"game" => answers}, socket) do
    IO.inspect(answers)
    {:noreply, socket}
  end
end
