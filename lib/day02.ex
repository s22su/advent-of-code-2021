defmodule AdventOfCode.Day02 do
  @moduledoc false
  use AdventOfCode

  import NimbleParsec

  def part1(input) do
    preprocess_input(input)
    |> Enum.reduce({0, 0}, fn instruction, acc -> move1(instruction, acc) end)
    |> (fn {x, y} -> x * y end).()
  end

  def part2(input) do
    preprocess_input(input)
    |> Enum.reduce({0, 0, 0}, fn instruction, acc -> move2(instruction, acc) end)
    |> (fn {x, y, _} -> x * y end).()
  end

  defp move1(["up", delta], {x, y}), do: {x, y - delta}
  defp move1(["down", delta], {x, y}), do: {x, y + delta}
  defp move1(["forward", delta], {x, y}), do: {x + delta, y}

  defp move2(["up", delta], {x, y, aim}), do: {x, y, aim - delta}
  defp move2(["down", delta], {x, y, aim}), do: {x, y, aim + delta}
  defp move2(["forward", delta], {x, y, aim}), do: {x + delta, y + aim * delta, aim}

  direction = choice([string("up"), string("down"), string("forward")])
  delta = ascii_string([?0..?9], min: 1) |> map({String, :to_integer, []})

  defparsec(
    :parse_lines,
    direction
    |> ignore(string(" "))
    |> concat(delta)
    |> ignore(string("\n"))
    |> wrap()
    |> repeat()
  )

  defp preprocess_input(input) do
    {:ok, parsed_input, _, _, _, _} = parse_lines(input)

    parsed_input
  end
end
