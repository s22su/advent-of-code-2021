defmodule AdventOfCode.Day06 do
  @moduledoc false
  use AdventOfCode

  import NimbleParsec

  def part1(input), do: preprocess_input(input) |> calc(0, 80)

  def part2(input), do: preprocess_input(input) |> calc(0, 256)

  def calc(states, curr_day, stop_day) when curr_day == stop_day,
    do: Map.values(states) |> Enum.sum()

  def calc(states, curr_day, stop_day) do
    new_count = Map.get(states, 0, 0)

    states
    |> Enum.filter(fn {state, _} -> state > 0 end)
    |> Enum.map(fn {state, count} -> {state - 1, count} end)
    |> Map.new()
    |> Map.update(6, new_count, fn c -> c + new_count end)
    |> Map.put(8, new_count)
    |> calc(curr_day + 1, stop_day)
  end

  number = ascii_string([?0..?9], min: 1) |> map({String, :to_integer, []})

  defparsec(
    :parse_lines,
    number
    |> optional(ignore(string(",")))
    |> repeat()
  )

  defp preprocess_input(input),
    do: String.trim(input) |> parse_lines() |> elem(1) |> Enum.frequencies()
end
