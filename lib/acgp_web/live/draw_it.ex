defmodule AcgpWeb.DrawIt do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "drawit:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)

    new_state = setup_specific_params(channel_id, general_params)

    {:ok, socket |> assign(new_state)}
  end

  def setup_specific_params(channel_id, general_params) do
    general_params |> GameState.inital_state(gen_questions())
  end

  def gen_questions() do
    answers = DrawIt.get_n_answers(5)

    %{
      img: "",
      possible_answers: answers,
      to_draw: Enum.random(answers)
    }
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

  def handle_event("guess", %{"user" => user, "answer" => answer}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    sync_state(socket, socket.assigns.game_state)
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_info(%{event: "sync_state", payload: %{state: state}}, socket) do
    {:noreply, socket |> assign(:game_state, state)}
  end

  def handle_info(%{event: "update_image", payload: %{img: img}}, socket) do
    {:noreply, socket |> assign(img: img)}
  end
end
