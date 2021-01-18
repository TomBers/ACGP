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
        answers: %{"Animals" => "Aardvark", "Movies" => "Star Wars", "Plants" => ""},
        name: "Player_1"
      },
      %{
        answers: %{"Animals" => "Aardvark", "Movies" => "Alien", "Plants" => ""},
        name: "Player_2"
      }
    ]

    # wrong_answers =
    wrong_answer_scores =
      inputs
      |> Enum.map(fn input ->
        %{name: input.name, score: calc_wrong_answers(input.answers, letter)}
      end)

    IO.inspect(wrong_answer_scores)

    # Filter worng answers
    f_ans =
      inputs |> Enum.map(fn ans -> %{name: ans.name, answers: filter_incorrect(ans, letter)} end)

    # Score duplications (if any dupes found -2 points)
    # score_ans(f_ans)
  end

  def calc_wrong_answers(input, letter) do
    score = input |> Enum.count(fn {_k, v} -> v == "" or !String.starts_with?(v, letter) end)

    score * -1
  end

  def dupes do
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

    inputs
    |> Enum.map(fn input -> return_dupe_score(input, inputs, letter) end)

    # count_all_dupes(my_answer, other_answers)
  end

  def return_dupe_score(input, all_answers, letter) do
    filtered_answers =
      all_answers
      |> Enum.filter(fn ans -> ans.name != input.name end)
      |> Enum.map(fn x -> filter_incorrect(x, letter) end)
      |> List.flatten()

    my_ans = Map.to_list(input.answers)
    %{name: input.name, score: count_all_dupes(my_ans, filtered_answers)}
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
