defmodule AdventOfCode.Day08 do
  @moduledoc false
  use AdventOfCode

  def part1(input) do
    preprocess_input(input)
    |> Enum.map(&elem(&1, 1))
    |> List.flatten()
    |> Enum.map(&String.length/1)
    |> Enum.frequencies()
    |> Enum.filter(&Enum.member?([2, 3, 4, 7], elem(&1, 0)))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(input) do
    # 0 = 6 seg
    # 1 = 2 seg
    # 2 = 5 seg
    # 3 = 5 seg
    # 4 = 4 seg
    # 5 = 5 seg
    # 6 = 6 seg
    # 7 = 3 seg
    # 8 = 7 seg
    # 9 = 6 seg

    preprocess_input(input)
    |> Enum.map(fn {signals, outputs} ->
      s =
        Enum.map(signals, fn s ->
          String.graphemes(s)
          |> Enum.sort()
        end)

      o =
        Enum.map(outputs, fn o ->
          String.graphemes(o) |> Enum.sort()
        end)

      all_uniq = (s ++ o) |> Enum.uniq() |> Enum.sort(&(length(&1) <= length(&2)))

      {s, o, all_uniq}
    end)
    |> Enum.map(fn {s, o, all} ->
      mappings =
        Enum.reduce(all, %{}, fn segment, acc ->
          new_acc =
            cond do
              length(segment) == 2 -> Map.put(acc, 1, segment)
              length(segment) == 4 -> Map.put(acc, 4, segment)
              length(segment) == 3 -> Map.put(acc, 7, segment)
              length(segment) == 7 -> Map.put(acc, 8, segment)
              true -> acc
            end

          new_acc
        end)

      {s, o, mappings}
    end)
    |> Enum.map(fn {s, o, mappings} ->
      one = Map.get(mappings, 1)
      four = Map.get(mappings, 4)
      # seven = Map.get(mappings, 7)
      eight = Map.get(mappings, 8)

      # top_segement = seven -- one
      top_left_and_middle_segments = four -- one
      # bottom_left_and_bottom_segments = (eight -- seven) -- four

      two_three_or_five =
        Enum.filter(s, fn c ->
          # numbers 2, 3 or 5
          length(c) == 5
        end)

      # 2 + 5 = 8
      # so the remaining one is 3

      n1 = Enum.at(two_three_or_five, 0)
      n2 = Enum.at(two_three_or_five, 1)
      n3 = Enum.at(two_three_or_five, 2)

      three =
        cond do
          (n1 ++ n2) |> Enum.uniq() |> Enum.sort() == Enum.sort(eight) -> n3
          (n1 ++ n3) |> Enum.uniq() |> Enum.sort() == Enum.sort(eight) -> n2
          (n2 ++ n3) |> Enum.uniq() |> Enum.sort() == Enum.sort(eight) -> n1
        end

      top_left_segment = four -- three

      # IO.inspect(top_left_segment, label: "top_left_segment")
      # IO.inspect(top_left_and_middle_segments, label: "top_left_and_middle_segments")

      middle_segment = top_left_and_middle_segments -- top_left_segment

      # IO.inspect(middle_segment, label: "middle_segment")

      zero = eight -- middle_segment

      nine = (three ++ top_left_and_middle_segments) |> Enum.uniq()

      # 6
      six =
        Enum.filter(s, fn c ->
          length(c) == 6 && Enum.sort(c) != Enum.sort(zero) && Enum.sort(c) != Enum.sort(nine)
        end)
        |> List.flatten()

      # 2 and 5 are missing
      two_or_five = Enum.filter(two_three_or_five, fn c -> c !== three end)

      n1 = Enum.at(two_or_five, 0)
      n2 = Enum.at(two_or_five, 1)

      # 2 + 6 = 8
      # 5 + 6 = 6
      five =
        cond do
          (n1 ++ six) |> Enum.uniq() |> Enum.sort() == Enum.sort(six) -> n1
          (n2 ++ six) |> Enum.uniq() |> Enum.sort() == Enum.sort(six) -> n2
        end

      two = Enum.filter(two_or_five, fn c -> c !== five end) |> List.flatten()

      final_mappings =
        mappings
        |> Map.put(0, Enum.sort(zero))
        |> Map.put(3, Enum.sort(three))
        |> Map.put(9, Enum.sort(nine))
        |> Map.put(6, Enum.sort(six))
        |> Map.put(2, Enum.sort(two))
        |> Map.put(5, Enum.sort(five))

      {o, final_mappings}
    end)
    |> Enum.map(fn {o, mappings} ->
      Enum.reduce(o, [], fn num, acc ->
        n = Enum.filter(mappings, fn {_, v} -> v == num end) |> Enum.at(0) |> elem(0)

        acc ++ [n]
      end)
      |> Enum.join()
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp preprocess_input(input) do
    input
    |> String.trim()
    |> String.replace(" |\n", "|")
    |> String.split("\n")
    |> Enum.map(fn s ->
      [f, s] = String.split(s, "|")

      f = String.split(f)
      s = String.split(s)

      {f, s}
    end)
  end
end
