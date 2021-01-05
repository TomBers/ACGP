defmodule AcgpWeb.AskHole do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "askhole:#{id}"

  def mount(%{"id" => room}, _session, socket) do
    channel_id = topic(room)
    general_params = StateManagement.setup_initial_state(channel_id, room)
    {:ok, socket |> assign(setup_specific_params(general_params))}
  end

  def setup_specific_params(general_params) do
    general_params
    |> Map.put(:question, "")
    |> Map.put(:connected, false)
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_event("new_card", _params, socket) do
    question = AskHole.get_question()

    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "synchronize", %{
      question: question
    })

    {:noreply, assign(socket, question: question)}
  end

  def handle_info(%{event: "synchronize", payload: %{question: question}}, socket) do
    {:noreply, assign(socket, question: question)}
  end

  def handle_info(%{event: "connect_state", payload: %{connected: connected}}, socket) do
    {:noreply, assign(socket, connected: connected)}
  end

  def handle_event("changeConnection", _state, socket) do
    new_connection_state = !socket.assigns.connected

    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "connect_state", %{
      connected: new_connection_state
    })

    {:noreply, assign(socket, connected: new_connection_state)}
  end
end
