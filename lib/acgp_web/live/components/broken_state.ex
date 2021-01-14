defmodule AcgpWeb.BrokenState do
  use AcgpWeb, :live_component

  def is_active_user_correct?(game_state, users) do
    Enum.any?(users, &(&1.name == game_state.active_user))
  end
end
