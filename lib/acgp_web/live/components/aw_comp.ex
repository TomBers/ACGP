defmodule AcgpWeb.AWComp do
  use AcgpWeb, :live_component

  def am_I_draw_king(my_name, users) do
    StateManagement.is_user_active(my_name, users)
  end
end
