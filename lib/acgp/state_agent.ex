defmodule StateAgent do

  use Agent, restart: :temporary


  def get_server(name) do
    case start_link(name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def start_link(name) do
    Agent.start_link(fn -> %{} end, [name: {:global, name}])
  end

  def get_or_generate(bucket, key, value) do
    case get(bucket, key) do
      nil -> put(bucket, key, value)
      data -> data
    end
  end


  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
    value
  end

end
