defmodule AdventOfCode.Day03 do
  @moduledoc false
  use AdventOfCode

  import NimbleParsec

  def part1(input) do
    preprocess_input(input)
    |> calculate_frequencies()
    |> Enum.reduce({"", ""}, fn {zeros_freq, one_freq}, {g, e} ->
      if one_freq > zeros_freq, do: {"#{g}1", "#{e}0"}, else: {"#{g}0", "#{e}1"}
    end)
    |> Tuple.to_list()
    |> Enum.map(&Integer.parse(&1, 2))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part2(input) do
    numbers = preprocess_input(input)
    oxygen = calculate_value(numbers, 0, "1")
    co2 = calculate_value(numbers, 0, "0")

    oxygen * co2
  end

  defp calculate_frequencies(numbers) do
    initial = List.duplicate({0, 0}, length(Enum.at(numbers, 0)))

    Enum.reduce(numbers, initial, fn bits, acc ->
      Enum.map(Enum.with_index(acc), fn {{z, o}, i} ->
        case Enum.at(bits, i) do
          "0" -> {z + 1, o}
          "1" -> {z, o + 1}
        end
      end)
    end)
  end

  defp calculate_value(numbers, pos, dominant_criteria) do
    {zeros_count, ones_count} = calculate_frequencies(numbers) |> Enum.at(pos)

    criteria =
      cond do
        ones_count > zeros_count -> dominant_criteria
        ones_count == zeros_count -> dominant_criteria
        true -> if dominant_criteria == "1", do: "0", else: "1"
      end

    new_numbers =
      Enum.filter(numbers, fn num ->
        Enum.at(num, pos) == criteria
      end)

    if(length(new_numbers) > 1) do
      calculate_value(new_numbers, pos + 1, dominant_criteria)
    else
      new_numbers
      |> List.flatten()
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)
    end
  end

  bin_num = ascii_string([?0..?9], min: 1)

  defparsec(
    :parse_lines,
    bin_num
    |> ignore(string("\n"))
    |> wrap()
    |> repeat()
  )

  defp preprocess_input(input) do
    parse_lines(input)
    |> elem(1)
    |> List.flatten()
    |> Enum.map(&String.codepoints/1)
  end
end
