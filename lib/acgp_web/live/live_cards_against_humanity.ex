defmodule AcgpWeb.LiveCardsAgainstHumanity do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "cah:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)
    {:ok, socket |> assign(setup_specific_params(general_params))}
  end

  def setup_specific_params(general_params) do
    general_params
      |> Map.put(:current_guesses, [])
      |> Map.put(:answer_cards, CardsAgainstHumanity.get_answer_cards(10))
      |> Map.put(:question_card, "")
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "winner", payload: %{winner: winner, question_card: question_card}}, socket) do
    StateManagement.increase_score(self(), topic(socket.assigns.room), winner, socket.assigns)
    #    Clear the current guesses
    {:noreply, socket |> assign(current_guesses: [], question_card: question_card)}
  end

  def handle_info(%{event: "new_guesses", payload: %{new_guesses: new_guesses}}, socket) do
    {:noreply, assign(socket, current_guesses: new_guesses)}
  end

  def handle_info(%{event: "synchronize", payload: %{question_card: question}}, socket) do
    {:noreply, assign(socket, question_card: question, current_guesses: [])}
  end


  def handle_event("winner", %{"user" => user}, socket) do
    pid = self()
    channel_id = topic(socket.assigns.room)
    my_name = socket.assigns.my_name
#    The current card czar has choosen a winner
#     Step 1 - declare themselves no longer the car czar
    StateManagement.set_no_longer_active(pid, channel_id, socket.assigns)

    question = CardsAgainstHumanity.get_board_card()
#    Step 2 - Send a message to everyone announcing the winner and pick new card
    AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "winner", %{winner: user, question_card: question })
    {:noreply, assign(socket, question_card: question, current_guesses: [])}
  end


  def handle_event("answer", %{"answer" => answer, "user" => user}, socket) do
#    I am suggesting a humorous answer to the board card
    new_guesses = [%{answer: answer, user: user} | socket.assigns.current_guesses]
#    I announce my answer to everyone
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "new_guesses", %{new_guesses: new_guesses})
    {:noreply, socket |> assign(current_guesses: new_guesses)}
  end

  def handle_event("start_game", _params, socket) do
#    Pick a board card and share it around
    question = CardsAgainstHumanity.get_board_card()
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "synchronize", %{question_card: question})
    {:noreply, assign(socket, question_card: question)}
  end

  def am_I_czar(my_name, users) do
    StateManagement.is_user_active(my_name, users)
  end

end
