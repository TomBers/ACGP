defmodule AcgpWeb.LiveAskHole do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "room:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    prefix = GameUtils.get_name()
    uid = GameUtils.get_id()

    name = "#{prefix}_#{uid}"

    Presence.track_presence(
      self(),
      topic(room),
      uid,
      %{name: name}
    )

    AcgpWeb.Endpoint.subscribe(topic(room))


    {:ok,
    assign(socket,
      room: room,
      name: name,
      question: "",
      users: Presence.list_presences(topic(room)) )}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_event("new_card", _params, socket) do
    question = AskHole.get_question()
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "synchronize", %{question: question})
    {:noreply, assign(socket, question: question)}
  end

  def handle_info(%{event: "synchronize", payload: %{question: question}}, socket) do
    {:noreply, assign(socket, question: question)}
  end

end
