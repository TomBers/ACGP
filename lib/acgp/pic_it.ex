defmodule PicIt do

  @ideas ["Acceptance", "Amusement", "Anger", "Angst", "Annoying", "Awe", "Boredom", "Confidence", "Contentment", "Courage", "Doubt", "Embarrassment", "Enthusiasm", "Envy", "Euphoria", "Faith", "Fear", "Frustration", "Gratitude", "Greed", "Guilt", "Happiness", "Hatred", "Hope", "Horror", "Hostility", "Humiliation", "Interest", "Jealousy", "Joy", "Kindness", "Loneliness", "Love", "Lust", "Nostalgia", "Outrage", "Panic", "Passion", "Pity", "Pleasure", "Pride", "Rage", "Regret", "Rejection", "Remorse", "Resentment", "Sadness"]

  def game_state(user \\ "") do
    %{
      active_user: user,
      idea: Enum.random(@ideas),
      images: [],
      answered: [],
      winner: nil
    }
  end

end
