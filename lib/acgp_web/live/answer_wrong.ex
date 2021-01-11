defmodule AcgpWeb.AnswerWrong do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "answerwrong:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)

    {:ok, socket |> assign(setup_specific_params(channel_id, general_params))}
  end

  def setup_specific_params(channel_id, general_params) do
    s = StateAgent.get_server(channel_id)
    state = gen_state(s)

    general_params
    |> Map.put(:state, state)
    |> Map.put(:current_guesses, [])
    |> Map.put(:server, s)
  end

  def gen_state(server, over_write? \\ false) do
    aw = AnswerWrong.get_question()

    potential_state = %{
      question: aw.question,
      answer: aw.answer
    }

    if over_write? do
      StateAgent.put(server, :state, potential_state)
    else
      StateAgent.get_or_generate(server, :state, potential_state)
    end
  end

  def handle_event("winner", %{"user" => user}, socket) do
    pid = self()
    channel_id = topic(socket.assigns.room)
    my_name = socket.assigns.my_name
    #    The current card czar has choosen a winner
    #     Step 1 - declare themselves no longer the car czar and maybe update score if they won
    StateManagement.change_user_and_maybe_inc_score(
      pid,
      channel_id,
      socket.assigns,
      my_name == user
    )

    state = gen_state(socket.assigns.server, true)
    #    Step 2 - Send a message to everyone announcing the winner and pick new card
    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "winner", %{winner: user})
    {:noreply, assign(socket, state: state, current_guesses: [])}
  end

  #  Events from Page
  def handle_info(%{event: "winner", payload: %{winner: winner}}, socket) do
    StateManagement.increase_score(self(), topic(socket.assigns.room), winner, socket.assigns)
    state = gen_state(socket.assigns.server)
    {:noreply, socket |> assign(state: state, current_guesses: [])}
  end

  def handle_event("myguess", %{"key" => key, "value" => value, "user" => user}, socket) do
    if key == "Enter" do
      new_guesses = [%{answer: value, user: user} | socket.assigns.current_guesses]

      new_guesses =
        if are_all_answers_in?(new_guesses, socket.assigns.users) do
          [
            %{
              answer: socket.assigns.state.answer,
              user: StateManagement.active_user(socket.assigns.users).name
            }
            | new_guesses
          ]
        else
          new_guesses
        end

      #    I announce my answer to everyone
      AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "new_guesses", %{
        new_guesses: new_guesses
      })

      {:noreply, socket |> assign(current_guesses: new_guesses)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(%{event: "new_guesses", payload: %{new_guesses: new_guesses}}, socket) do
    {:noreply, assign(socket, current_guesses: new_guesses)}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def am_I_draw_king(my_name, users) do
    StateManagement.is_user_active(my_name, users)
  end

  def are_all_answers_in?(current_guesses, users) do
    length(current_guesses) >= length(users) - 1
  end
end