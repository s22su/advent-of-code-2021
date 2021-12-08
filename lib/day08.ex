defmodule AdventOfCode.Day08 do
  @moduledoc false
  use AdventOfCode

  def part1(input) do
    preprocess_input(input)
    |> Enum.map(&Enum.at(&1, 1))
    |> List.flatten()
    |> Enum.map(&String.length/1)
    |> Enum.frequencies()
    |> Enum.filter(&Enum.member?([2, 3, 4, 7], elem(&1, 0)))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(input) do
    preprocess_input(input)
    |> Enum.map(fn [signals, outputs] ->
      signals =
        Enum.map(signals, fn s ->
          String.graphemes(s) |> Enum.sort()
        end)

      outputs =
        Enum.map(outputs, fn o ->
          String.graphemes(o) |> Enum.sort()
        end)

      all_numbers = Enum.uniq(signals ++ outputs)

      {signals, outputs, all_numbers}
    end)
    |> Enum.map(fn {signals, outputs, all_numbers} ->
      mappings =
        Enum.reduce(all_numbers, %{}, fn segment, acc ->
          cond do
            length(segment) == 2 -> Map.put(acc, 1, segment)
            length(segment) == 4 -> Map.put(acc, 4, segment)
            length(segment) == 3 -> Map.put(acc, 7, segment)
            length(segment) == 7 -> Map.put(acc, 8, segment)
            true -> acc
          end
        end)

      {signals, outputs, mappings}
    end)
    |> Enum.map(fn {signals, outputs, mappings} ->
      one = Map.get(mappings, 1)
      four = Map.get(mappings, 4)
      # seven = Map.get(mappings, 7)
      eight = Map.get(mappings, 8)

      two_three_or_five = Enum.filter(signals, &(length(&1) == 5))

      n1 = Enum.at(two_three_or_five, 0)
      n2 = Enum.at(two_three_or_five, 1)
      n3 = Enum.at(two_three_or_five, 2)

      three =
        cond do
          # 2 + 5 = 8, so the remaining one is 3
          sum_segements(n1, n2) == eight -> n3
          sum_segements(n1, n3) == eight -> n2
          sum_segements(n2, n3) == eight -> n1
        end

      zero =
        sub_segements(
          eight,
          sub_segements(
            sub_segements(four, one),
            sub_segements(four, three)
          )
        )

      nine = sum_segements(three, sub_segements(four, one))

      six = Enum.filter(signals, &(length(&1) == 6 && &1 != zero && &1 != nine)) |> List.flatten()

      two_or_five = Enum.reject(two_three_or_five, &(&1 == three))

      n1 = Enum.at(two_or_five, 0)
      n2 = Enum.at(two_or_five, 1)

      # 2 + 6 = 8
      # 5 + 6 = 6
      five =
        cond do
          sum_segements(n1, six) == six -> n1
          sum_segements(n2, six) == six -> n2
        end

      two = Enum.reject(two_or_five, &(&1 == five)) |> List.flatten()

      final_mappings =
        mappings
        |> Map.put(0, zero)
        |> Map.put(2, two)
        |> Map.put(3, three)
        |> Map.put(5, five)
        |> Map.put(6, six)
        |> Map.put(9, nine)

      {outputs, final_mappings}
    end)
    |> Enum.map(fn {outputs, mappings} ->
      Enum.reduce(outputs, [], fn num, acc ->
        acc ++ [Enum.filter(mappings, fn {_, v} -> v == num end) |> Enum.at(0) |> elem(0)]
      end)
      |> Enum.join()
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp sum_segements(s1, s2), do: (s1 ++ s2) |> Enum.uniq() |> Enum.sort()
  defp sub_segements(s1, s2), do: (s1 -- s2) |> Enum.sort()

  defp preprocess_input(input) do
    input
    |> String.trim()
    |> String.replace(" |\n", "|")
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, "|")
      |> Enum.map(&String.split/1)
    end)
  end
end
