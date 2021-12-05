defmodule AdventOfCode.Day05 do
  @moduledoc false
  use AdventOfCode

  import NimbleParsec

  def part1(input) do
    lines =
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

    lines
    |> init_empty_board()
    |> put_lines(lines)
    |> Enum.filter(fn {_k, v} -> v > 1 end)
    |> Enum.count()
  end

  def part2(input) do
    lines =
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

    lines
    |> init_empty_board()
    |> put_lines(lines)
    |> Enum.filter(fn {_k, v} -> v > 1 end)
    |> Enum.count()
  end

  defp put_lines(board, lines),
    do: Enum.reduce(lines, board, fn line_coords, acc -> put_line(acc, line_coords) end)

  defp put_line(board, coords),
    do:
      Enum.reduce(coords, board, fn {x, y}, acc -> Map.update!(acc, {x, y}, fn v -> v + 1 end) end)

  defp init_empty_board(lines) do
    {max_x, max_y} = find_max_xy(lines)

    for(x <- 0..max_x, y <- 0..max_y, do: {x, y})
    |> Enum.reduce(%{}, fn k, acc -> Map.put(acc, k, 0) end)
  end

  defp find_max_xy(coords) do
    Enum.reduce(coords, {0, 0}, fn line, {max_x, max_y} ->
      c_max_x = Enum.max_by(line, fn {x, _y} -> x end) |> elem(0)
      c_max_y = Enum.max_by(line, fn {_x, y} -> y end) |> elem(1)

      {Enum.max([max_x, c_max_x]), Enum.max([max_y, c_max_y])}
    end)
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
