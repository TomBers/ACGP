defmodule AcgpWeb.AnswerWrong do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "answerwrong:#{id}"

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
    aw = AnswerWrong.get_question()

    %{
      active_user: user,
      question: aw.question,
      answer: aw.answer,
      selected_answer: nil
    }
  end

  def empty_game_state do
    %{
      game_state: %{
        active_user: nil,
        question: "",
        answer: "",
        selected_answer: nil
      },
      my_name: "",
      users: []
    }
  end

  def win_condition(state, users) do
    {true, Enum.find(state.answered, fn ans -> ans.guess == state.selected_answer end).name}
  end

  def sync_state(socket, new_state) do
    pid = self()

    GameState.update_state(new_state, socket.assigns.channel_id)

    AcgpWeb.Endpoint.broadcast_from(pid, socket.assigns.channel_id, "sync_state", %{
      state: new_state
    })

    {:noreply, socket |> assign(game_state: new_state)}
  end

  def handle_event("myguess", %{"key" => key, "value" => value, "user" => user}, socket) do
    if key == "Enter" do
      new_state = GameState.add_answered(socket.assigns.game_state, %{name: user, guess: value})

      new_state =
        if length(new_state.answered) >= length(socket.assigns.users) - 1 do
          GameState.add_answered(new_state, %{
            name: new_state.active_user,
            guess: new_state.answer
          })
        else
          new_state
        end

      sync_state(socket, new_state)
    else
      {:noreply, socket}
    end
  end

  def handle_event("pick_winner", %{"answer" => ans, "user" => user, "value" => _}, socket) do
    gs = GameState.set_field(socket.assigns.game_state, :selected_answer, ans)

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

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(socket.assigns.channel_id))}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end
end
