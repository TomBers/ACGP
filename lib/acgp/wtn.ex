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
end
