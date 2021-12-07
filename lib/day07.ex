defmodule AdventOfCode.Day07 do
  @moduledoc false
  use AdventOfCode

  import NimbleParsec

  def part1(input) do
    positions = preprocess_input(input)

    med = positions |> Enum.sort() |> Enum.at(div(length(positions), 2))

    Enum.reduce(positions, 0, fn n, acc ->
      if n == med, do: acc, else: acc + abs(n - med)
    end)
  end

  def part2(input) do
    positions = preprocess_input(input)

    sum = Enum.sum(positions)
    avg = sum / Enum.count(positions)

    final_pos1 = round(avg)
    final_pos2 = floor(avg)

    possible_final_positions = [final_pos1, final_pos2]

    possible_final_positions
    |> Enum.map(fn final_position ->
      result =
        Enum.reduce(positions, 0, fn n, acc ->
          steps =
            cond do
              n == final_position -> 0
              n > final_position -> n - final_position
              n < final_position -> abs(n - final_position)
            end

          if steps == 0 do
            acc
          else
            acc + Enum.sum(1..steps)
          end
        end)

      {result, final_position}
    end)
    |> Enum.min()
    |> elem(0)
  end

  number = ascii_string([?0..?9], min: 1) |> map({String, :to_integer, []})

  defparsec(
    :parse_lines,
    number
    |> optional(ignore(string(",")))
    |> repeat()
  )

  defp preprocess_input(input), do: String.trim(input) |> parse_lines() |> elem(1)
end
