defmodule AcgpWeb.AWAnsComp do
  use AcgpWeb, :live_component

  def are_all_answers_in?(current_guesses, users) do
    length(current_guesses) >= length(users) - 1
  end
end
