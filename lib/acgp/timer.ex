defmodule ACGP.Timer do
  use GenServer

  def start(parent_id) do
    secs = 1000
    mins = secs * 60

    {:ok, pid} = GenServer.start(ACGP.Timer, parent_id)
    :timer.send_interval(secs, pid, :tick)
    pid
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_info(:stop_counters, state) do
    {:stop, 'stopped', nil}
  end

  def handle_info(:tick, parent_id) do
    send(parent_id, :tick)
    {:noreply, parent_id}
  end
end
