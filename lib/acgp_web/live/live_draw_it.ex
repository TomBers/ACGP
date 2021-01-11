defmodule AcgpWeb.LiveDrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "drawit:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)

    {:ok, socket |> assign(setup_specific_params(channel_id, general_params))}
  end

  def setup_specific_params(channel_id, general_params) do
    s = StateAgent.get_server(channel_id)
    state = gen_state(s)

    general_params
    |> Map.put(:img, "")
    |> Map.put(:state, state)
    |> Map.put(:server, s)
  end

  def gen_state(server, over_write? \\ false) do
    answers = DrawIt.get_n_answers(5)

    potential_state = %{
      possible_answers: answers,
      to_draw: Enum.random(answers),
      current_answers: []
    }

    update_state(server, potential_state, over_write?)
  end

  def update_state(server, potential_state, over_write? \\ false) do
    if over_write? do
      StateAgent.put(server, :state, potential_state)
    else
      StateAgent.get_or_generate(server, :state, potential_state)
    end
  end

  #  Events from Page

  def handle_event("drawit", img, socket) do
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "update_image", %{
      img: img
    })

    {:noreply, socket}
  end

  def handle_event("guess", %{"user" => user, "answer" => answer}, socket) do
    pid = self()
    channel_id = topic(socket.assigns.room)
    state = StateAgent.get(socket.assigns.server, :state)
    # See if we have a winner
    is_winner? = state.to_draw == answer
    overwrite_state = true

    state =
      if is_winner? do
        gen_state(socket.assigns.server, overwrite_state)
      else
        update_state(
          socket.assigns.server,
          %{
            possible_answers: state.possible_answers,
            to_draw: state.to_draw,
            current_answers: [%{user => answer} | state.current_answers]
          },
          overwrite_state
        )
      end

    if is_winner? do
      StateManagement.increase_score(pid, channel_id, user, socket.assigns)
      AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "no-longer-drawing", %{winner: user})
    else
      if are_all_answers_in?(state.current_answers, socket.assigns.users) do
        AcgpWeb.Endpoint.broadcast_from(pid, channel_id, "no-longer-drawing", %{
          winner: StateManagement.active_user(socket.assigns.users).name
        })
      end
    end

    {:noreply, socket |> assign(state: state)}
  end

  def handle_info(%{event: "no-longer-drawing", payload: %{winner: winner}}, socket) do
    pid = self()
    channel_id = topic(socket.assigns.room)
    state = socket.assigns.state
    my_name = socket.assigns.my_name

    StateManagement.change_user_and_maybe_inc_score(
      pid,
      channel_id,
      socket.assigns,
      my_name == winner
    )

    {:noreply,
     socket
     |> assign(
       :state,
       gen_state(
         socket.assigns.server,
         are_all_answers_in?(state.current_answers, socket.assigns.users)
       )
     )}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    {:noreply, socket |> assign(img: img)}
  end

  def handle_info(%{event: "change_is_active", payload: %{user: user}}, socket) do
    StateManagement.update_my_presence(
      self(),
      topic(socket.assigns.room),
      socket.assigns.my_name,
      false
    )

    {:noreply, socket |> assign(img: "")}
  end

  def am_I_draw_king(my_name, users) do
    StateManagement.is_user_active(my_name, users)
  end

  def are_all_answers_in?(current_guesses, users) do
    length(current_guesses) >= length(users) - 1
  end
end
