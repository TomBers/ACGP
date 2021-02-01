defmodule Abundance do

  def game_state(_p) do
    %{
      active_user: nil,
      answered: [],
      winner: nil
    }
  end

  def gen_cells() do
    1..100 |> Enum.map(fn _x -> Enum.random([0]) end)
  end

end
