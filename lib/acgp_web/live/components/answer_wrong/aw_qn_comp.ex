defmodule AcgpWeb.AWQnComp do
  use AcgpWeb, :live_component

  def i_have_answered(current_guesses, my_name) do
    Enum.any?(current_guesses, fn guess -> guess.user == my_name end)
  end

  def are_all_answers_in?(current_guesses, users) do
    length(current_guesses) >= length(users) - 1
  end
end
