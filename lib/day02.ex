defmodule AdventOfCode.Day02 do
  @moduledoc false
  use AdventOfCode

  import NimbleParsec

  def part1(input) do
    preprocess_input(input)
    |> Enum.reduce(%{x: 0, y: 0}, fn instruction, acc -> move1(instruction, acc) end)
    |> (fn %{x: x, y: y} -> x * y end).()
  end

  def part2(input) do
    preprocess_input(input)
    |> Enum.reduce(%{x: 0, y: 0, aim: 0}, fn instruction, acc -> move2(instruction, acc) end)
    |> (fn %{x: x, y: y} -> x * y end).()
  end

  defp move1(["up", delta], %{y: y} = curr), do: Map.put(curr, :y, y - delta)
  defp move1(["down", delta], %{y: y} = curr), do: Map.put(curr, :y, y + delta)
  defp move1(["forward", delta], %{x: x} = curr), do: Map.put(curr, :x, x + delta)

  defp move2(["up", delta], %{aim: aim} = curr), do: Map.put(curr, :aim, aim - delta)
  defp move2(["down", delta], %{aim: aim} = curr), do: Map.put(curr, :aim, aim + delta)

  defp move2(["forward", delta], %{x: x, y: y, aim: aim} = curr),
    do: Map.merge(curr, %{x: x + delta, y: y + aim * delta})

  direction = choice([string("up"), string("down"), string("forward")])
  delta = ascii_string([?0..?9], min: 1) |> map({String, :to_integer, []})

  parser =
    direction
    |> ignore(string(" "))
    |> concat(delta)

  defparsec(:parse_line, parser)

  defp preprocess_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {:ok, result, _, _, _, _} -> result end)
  end
end
