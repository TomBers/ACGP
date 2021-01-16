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
    |> Enum.map(fn _x -> Enum.random(@categories) end)
  end
end
