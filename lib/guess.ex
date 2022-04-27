defmodule Guess do
  use Application

  @scores %{
    (1..1) => "You're a mind rider!",
    (2..4) => "Most impresive!",
    (3..6) => "You can do better than that!"
  }

  def start(_, _) do
    run()
    {:ok, self()}
  end

  def run() do
    IO.puts("Let's play Guess the Number")

    IO.gets("Pick a difficult level (1, 2 or 3): ")
    |> parse_input()
    |> pickup_number()
    |> play()
  end

  def pickup_number(level) do
    level
    |> get_range()
    |> Enum.random()
  end

  def play(picked_number) do
    IO.gets("I have my number. What is your guess? ")
    |> parse_input()
    |> guess(picked_number, 1)
  end

  def guess(user_guess, picked_number, count) when user_guess > picked_number do
    IO.gets("Too high. Guess again: ")
    |> parse_input()
    |> guess(picked_number, count + 1)
  end

  def guess(user_guess, picked_number, count) when user_guess < picked_number do
    IO.gets("Too low. Guess again: ")
    |> parse_input()
    |> guess(picked_number, count + 1)
  end

  def guess(_, _, count) do
    IO.puts("You got it #{count} guess!")
    show_score(count)
  end

  def show_score(guesses) when guesses > 6 do
    IO.puts("Better luck next time!")
  end

  def show_score(guesses) do
    {_, msg} =
      @scores
      |> Enum.find(fn {range, _} -> Enum.member?(range, guesses) end)

    IO.puts(msg)
  end

  def parse_input(:error) do
    IO.puts("Invalid input!")
    run()
  end

  def parse_input({number, _}), do: number

  def parse_input(data) do
    data
    |> Integer.parse()
    |> parse_input()
  end

  def get_range(level) do
    case level do
      1 -> 1..10

      2 -> 1..100

      3 -> 1..1000

      _ ->
        IO.puts("Invalid level!")
        run()
    end
  end
end
