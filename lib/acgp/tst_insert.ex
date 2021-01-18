defmodule TstInsert do
  def test_run do
    state = %{
      active_user: "Church_526",
      answered: [
        %{
          answered: %{"Authors" => "", "Countries" => "", "Islands" => "ABC"},
          name: "Church_526"
        }
      ],
      categories: ["Islands", "Countries", "Authors"],
      letter: "O",
      scores: %{},
      time: 12,
      users_answered: [],
      winner: nil
    }

    new_answered = %{
      answered: %{"Authors" => "", "Countries" => "", "Islands" => "ZXQ"},
      name: "TEST_526"
    }

    update_in(state, [:answered], &insert_into(&1, new_answered))
  end

  def insert_into(existing, new) do
    IO.inspect(existing)
    IO.inspect(Enum.any?(existing, fn %{name: name, answered: _a} -> name == new.name end))

    if Enum.any?(existing, fn %{name: name, answered: _a} -> name == new.name end) do
      insert_existing(existing, new)
    else
      insert_new(existing, new)
    end
  end

  def insert_new(existing, new) do
    [new | existing]
  end

  def insert_existing(existing, new) do
    existing
    |> Enum.map(fn elem ->
      Map.update(elem, :answered, elem.answered, fn existing_val -> new.answered end)
    end)
  end
end
