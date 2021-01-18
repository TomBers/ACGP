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
    "Kings & Queens",
    "Chemical Elements",
    "Musicians",
    "Movies",
    "First Names",
    "Books",
    "Authors",
    "Politicians"
  ]

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

  def calc_scores do
    letter = "A"

    inputs = [
      %{
        answers: %{"Animals" => "Aardvark", "Movies" => "Argo", "Plants" => "ACACIA"},
        name: "Player_1"
      },
      %{
        answers: %{"Animals" => "Ant", "Movies" => "Alien", "Plants" => "ABELIA"},
        name: "Player_2"
      },
      %{
        answers: %{"Animals" => "Aardvark", "Movies" => "Alien", "Plants" => "ABELIA"},
        name: "Player_3"
      }
    ]

    # wrong_answers =
    wrong_answer_scores =
      inputs
      |> Enum.map(fn input -> calc_wrong_answers(input, letter) end)

    dupe_scores =
      inputs
      |> Enum.map(fn input -> calc_dupe_score(input, inputs, letter) end)

    inputs
    |> Enum.map(fn x -> %{name: x.name, score: length(Map.keys(x.answers))} end)
    |> Enum.map(fn x ->
      Map.update!(x, :score, &(&1 + get_score(dupe_scores, wrong_answer_scores, x.name)))
    end)
  end

  def get_score(sl1, sl2, name) do
    s1 = Enum.find(sl1, fn score -> score.name == name end).score
    s2 = Enum.find(sl2, fn score -> score.name == name end).score
    s1 + s2
  end

  def calc_wrong_answers(input, letter) do
    score =
      input.answers |> Enum.count(fn {_k, v} -> v == "" or !String.starts_with?(v, letter) end)

    %{name: input.name, score: score * -1}
  end

  def calc_dupe_score(input, all_answers, letter) do
    filtered_answers =
      all_answers
      |> Enum.filter(fn ans -> ans.name != input.name end)
      |> Enum.map(fn x -> filter_incorrect(x, letter) end)
      |> List.flatten()

    my_ans = Map.to_list(input.answers)
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
    Enum.filter(ans.answers, fn {k, v} -> !(v == "") and String.starts_with?(v, letter) end)
  end
end
