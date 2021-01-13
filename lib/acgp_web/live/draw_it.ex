defmodule AcgpWeb.DrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "drawit:#{id}"

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
    qns = gen_questions(params.my_name)
    params |> GameState.initial_state(qns, params.channel_id)
  end

  def gen_questions(user \\ "") do
    answers = DrawIt.get_n_answers(5)

    %{
      active_user: user,
      img: "",
      possible_answers: answers,
      to_draw: Enum.random(answers)
    }
  end

  def empty_game_state do
    %{
      game_state: %{
        active_user: nil,
        answered: [],
        img: "",
        possible_answers: [],
        scores: %{},
        to_draw: nil,
        winner: nil
      },
      my_name: "",
      users: []
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

    GameState.update_state(new_state, socket.assigns.channel_id)

    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{
      state: new_state
    })

    {:noreply, socket |> assign(game_state: new_state)}
  end

  #  Events from Page

  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), socket.assigns.channel_id, "update_image", %{img: img})

    {:noreply, socket}
  end

  def handle_event("guess", %{"user" => user, "answer" => answer}, socket) do
    new_state =
      GameState.add_answered(socket.assigns.game_state, %{name: user, guess: answer})
      |> GameState.check_winner(socket.assigns.users, &win_condition/2, &gen_questions/0)

    sync_state(socket, new_state)
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    cid = socket.assigns.channel_id
    users = Presence.list_presences(cid)
    gs = socket.assigns.game_state

    if !Enum.any?(users, fn user -> user.name == gs.active_user end) do
      sync_state(socket, GameState.set_controller(gs, List.first(users).name))
    end

    if length(users) == 0 do
      GameState.clear_state(cid)
    end

    {:noreply, socket |> assign(users: users)}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    sync_state(socket, GameState.set_field(socket.assigns.game_state, :img, img))
  end
end
