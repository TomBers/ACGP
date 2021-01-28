defmodule WTN do
  @letters [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ]

  @categories [
    "Countries",
    "Celebrities",
    "Cites",
    "Criminals",
    "Rivers",
    "Animals",
    "Plants",
    "Furniture",
    "Food",
    "Drinks",
    "Festivals",
    "Islands",
    "Kings_&_Queens",
    "Chemical_Elements",
    "Musicians",
    "Movies",
    "First_Names",
    "Books",
    "Authors",
    "Politicians"
  ]

  @timer_time 60


  def game_state(user \\ "") do
    letter = letter()
    categories = categories(3)

    %{
      active_user: user,
      letter: letter,
      categories: categories,
      users_answered: [],
      answered: [],
      time: @timer_time
    }
  end

  def update_scores(gs) do
    gs
        |> put_in([:scores], calc_scores(gs))
        |> put_in([:letter], letter())
        |> put_in([:categories], categories(3))
        |> put_in([:answered], [])
        |> put_in([:time], @timer_time)
        |> put_in([:users_answered], [])
  end

  def letter do
    Enum.random(@letters)
  end

  def categories(num) do
    1..num
    |> Enum.reduce([], fn _x, acc -> add_unique(acc) end)
  end

  def add_unique(acc) do
    cat = Enum.random(@categories)

    if Enum.any?(acc, &(&1 == cat)) do
      add_unique(acc)
    else
      [cat | acc]
    end
  end

  def tst_cals_scores do
    state = %{
      active_user: "Ship_922",
      answered: [
        # %{
        #   answers: %{"Animals" => "", "Furniture" => "L", "Rivers" => "L"},
        #   name: "Ship_922"
        # }
      ],
      categories: ["Animals", "Rivers", "Furniture"],
      letter: "L",
      scores: %{"Ship_922" => 3},
      time: 0,
      users_answered: [],
      winner: nil
    }

    calc_scores(state)
  end

  def calc_scores(state) do
    letter = state.letter
    existing_scores = state.scores
    inputs = state.answered

    # wrong_answers =
    wrong_answer_scores =
      inputs
      |> Enum.map(fn input -> calc_wrong_answers(input, letter) end)

    dupe_scores =
      inputs
      |> Enum.map(fn input -> calc_dupe_score(input, inputs, letter) end)

    new_scores =
      inputs
      |> Enum.map(fn x -> %{name: x.name, score: length(Map.keys(x.answered))} end)
      |> Enum.map(fn x ->
        Map.update!(x, :score, &(&1 + get_score(dupe_scores, wrong_answer_scores, x.name)))
      end)
      |> Enum.reduce(%{}, fn %{name: name, score: score}, acc ->
        Map.put(acc, name, score)
      end)

    Map.merge(existing_scores, new_scores, fn k, v1, v2 -> v1 + v2 end)
  end

  def get_score(sl1, sl2, name) do
    s1 = Enum.find(sl1, fn score -> score.name == name end).score
    s2 = Enum.find(sl2, fn score -> score.name == name end).score
    s1 + s2
  end

  def calc_wrong_answers(input, letter) do
    score =
      input.answered |> Enum.count(fn {_k, v} -> v == "" or !String.starts_with?(v, letter) end)

    %{name: input.name, score: score * -1}
  end

  def calc_dupe_score(input, all_answers, letter) do
    filtered_answers =
      all_answers
      |> Enum.filter(fn ans -> ans.name != input.name end)
      |> Enum.map(fn x -> filter_incorrect(x, letter) end)
      |> List.flatten()

    my_ans = Map.to_list(input.answered)
    %{name: input.name, score: count_all_dupes(my_ans, filtered_answers) * -2}
  end

  def count_all_dupes(my_answer, other_answers) do
    my_answer
    |> Enum.reduce(0, fn ans, acc -> acc + count_dupes(ans, other_answers) end)
  end

  def count_dupes(my_answer, other_answers) do
    other_answers |> Enum.count(fn ans -> ans == my_answer end)
  end

  def filter_incorrect(ans, letter) do
    Enum.filter(ans.answered, fn {k, v} -> !(v == "") and String.starts_with?(v, letter) end)
  end
end
