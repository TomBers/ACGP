defmodule AcgpWeb.DrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "drawit:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)
    {:ok, socket |> assign(setup_specific_params(channel_id, general_params))}
  end

  def setup_specific_params(channel_id, general_params) do
    general_params |> GameState.initial_state(gen_questions(), channel_id)
  end

  def gen_questions() do
    answers = DrawIt.get_n_answers(5)

    %{
      img: "",
      possible_answers: answers,
      to_draw: Enum.random(answers)
    }
  end

  def win_condition(state, users) do
    if length(state.answered) == length(users) - 1 do
      {true, GameState.who_won(state, users)}
    else
      {false, nil}
    end
  end

  def sync_state(socket, new_state) do
    pid = self()
    channel_id = topic(socket.assigns.room)

    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "sync_state", %{
      state: new_state
    })

    {:noreply, socket |> assign(game_state: new_state)}
  end

  #  Events from Page

  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "update_image", %{
      img: img
    })

    {:noreply, socket}
  end

  def handle_event("print_state", _p, socket) do
    IO.inspect(socket.assigns)
    {:noreply, socket}
  end

  def handle_event("clear_state", _p, socket) do
    sync_state(socket, GameState.reset_state(&gen_questions/0))
  end

  def handle_event("guess", %{"user" => user, "answer" => answer}, socket) do
    new_state =
      GameState.add_answered(socket.assigns.game_state, %{name: user, guess: answer})
      |> GameState.check_winner(socket.assigns.users, &win_condition/2, &gen_questions/0)

    sync_state(
      socket,
      new_state
    )
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    # TODO - the joining process is not quite right
    users = Presence.list_presences(socket.assigns.channel_id)
    game_state = GameState.set_controller(socket.assigns.game_state, Enum.random(users).name)

    sync_state(
      socket,
      game_state
    )

    {:noreply,
     socket
     |> assign(users: users, game_state: game_state)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    new_state = GameState.set_field(socket.assigns.game_state, :img, img)
    sync_state(socket, new_state)
  end
end
