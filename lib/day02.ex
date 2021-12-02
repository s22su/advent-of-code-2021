defmodule AdventOfCode.Day02 do
  @moduledoc false
  use AdventOfCode

  def part1(input) do
    %{x: x, y: y} =
      preprocess_input(input)
      |> Enum.reduce(%{x: 0, y: 0}, fn instruction, acc -> move1(instruction, acc) end)

    x * y
  end

  def part2(input) do
    %{x: x, y: y} =
      preprocess_input(input)
      |> Enum.reduce(%{x: 0, y: 0, aim: 0}, fn instruction, acc -> move2(instruction, acc) end)

    x * y
  end

  defp move1(["up", delta], %{y: y} = curr), do: Map.put(curr, :y, y - delta)
  defp move1(["down", delta], %{y: y} = curr), do: Map.put(curr, :y, y + delta)
  defp move1(["forward", delta], %{x: x} = curr), do: Map.put(curr, :x, x + delta)

  defp move2(["up", delta], %{aim: aim} = curr), do: Map.put(curr, :aim, aim - delta)
  defp move2(["down", delta], %{aim: aim} = curr), do: Map.put(curr, :aim, aim + delta)

  defp move2(["forward", delta], %{x: x, y: y, aim: aim} = curr),
    do: Map.merge(curr, %{x: x + delta, y: y + aim * delta})

  defp preprocess_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn el -> el !== "" end)
    |> Enum.map(fn ins ->
      [direction, delta] = String.split(ins, " ")

      [direction, String.to_integer(delta)]
    end)
  end
end
