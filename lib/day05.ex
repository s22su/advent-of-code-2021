defmodule AdventOfCode.Day05 do
  @moduledoc false
  use AdventOfCode

  import NimbleParsec

  def part1(input) do
    preprocess_input(input)
    |> Enum.map(fn [[x1, y1], [x2, y2]] ->
      cond do
        x1 == x2 ->
          for y <- y1..y2, do: {x1, y}

        y1 == y2 ->
          for x <- x1..x2, do: {x, y1}

        true ->
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_k, v} -> v > 1 end)
    |> Enum.count()
  end

  def part2(input) do
    preprocess_input(input)
    |> Enum.map(fn [[x1, y1], [x2, y2]] ->
      cond do
        x1 == x2 ->
          for y <- y1..y2, do: {x1, y}

        y1 == y2 ->
          for x <- x1..x2, do: {x, y1}

        true ->
          Enum.zip(x1..x2, y1..y2)
      end
    end)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_k, v} -> v > 1 end)
    |> Enum.count()
  end

  number = ascii_string([?0..?9], min: 1) |> map({String, :to_integer, []})

  defparsec(
    :parse_lines,
    number
    |> ignore(string(","))
    |> concat(number)
    |> ignore(string(" -> "))
    |> concat(number)
    |> ignore(string(","))
    |> concat(number)
    |> ignore(string("\n"))
    |> wrap()
    |> repeat()
  )

  defp preprocess_input(input),
    do: parse_lines(input) |> elem(1) |> Enum.map(&Enum.chunk_every(&1, 2))
end
