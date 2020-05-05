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

  def handle_info(%{event: "winner", payload: %{winner: user}}, socket) do
    #    The winner has been announced - is it me?
    if user == socket.assigns.my_name do
      #     I was indeed the winner - so I will update my score. and set myself as the Card Czar
      user_details = socket.assigns.users |> Enum.filter(fn(usr) -> usr.name == user end) |> List.first
      Presence.update_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, %{name: socket.assigns.my_name, score: user_details.score + 1, is_active: true})
    end
    #    Clear the current guesses
    {:noreply, socket |> assign(current_guesses: [])}
  end

  def handle_info(%{event: "new_guesses", payload: %{new_guesses: new_guesses}}, socket) do
    {:noreply, assign(socket, current_guesses: new_guesses)}
  end

  def handle_info(%{event: "synchronize", payload: %{question_card: question}}, socket) do
    {:noreply, assign(socket, question_card: question, current_guesses: [])}
  end


  def handle_event("winner", %{"user" => user}, socket) do
#    The current card czar has choosen a winner
#     Step 1 - declare themselves no longer the car czar
    user_details = socket.assigns.users |> Enum.filter(fn(usr) -> usr.name == socket.assigns.my_name end) |> List.first
    Presence.update_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, %{name: socket.assigns.my_name, score: user_details.score, is_active: false})

#    Step 2 - Send a message to everyone announcing the winner
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "winner", %{winner: user})

#    Step 3 - pick a new board card and send it to everyone
    question = CardsAgainstHumanity.get_board_card()
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "synchronize", %{question_card: question})
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
    ur = users |> Enum.filter(fn(usr) -> usr.name == my_name end) |> List.first
    ur.is_active
  end

end
