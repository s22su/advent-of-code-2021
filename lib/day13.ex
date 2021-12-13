defmodule AdventOfCode.Day13 do
  @moduledoc false
  use AdventOfCode

  @empty_cell " "
  @filled_cell "█"

  def part1(input) do
    {grid, instructions} = preprocess_input(input)

    grid
    |> fold(Enum.at(instructions, 0))
    |> Enum.count(fn {_, v} -> v == @filled_cell end)
  end

  def part2(input) do
    {grid, instructions} = preprocess_input(input)

    Enum.reduce(instructions, grid, fn instruction, acc -> fold(acc, instruction) end)
    |> print_grid()

    nil
  end

  defp fold(grid, {"y", fold_y}) do
    # split grids
    {top_grid, bottom_grid} =
      Enum.reduce(grid, {%{}, %{}}, fn {{x, y}, value}, {top_grid, bottom_grid} ->
        if y < fold_y do
          {Map.put(top_grid, {x, y}, value), bottom_grid}
        else
          {top_grid, Map.put(bottom_grid, {x, y}, value)}
        end
      end)

    bottom_ones =
      bottom_grid
      |> Enum.filter(fn {{_x, _y}, value} -> value == @filled_cell end)
      # re-calculate coordinates
      |> Enum.map(fn {{x, y}, value} ->
        {{x, abs(y - 2 * fold_y)}, value}
      end)
      |> Map.new()

    Map.merge(top_grid, bottom_ones)
  end

  defp fold(grid, {"x", fold_x}) do
    # split grids
    {left_grid, right_grid} =
      Enum.reduce(grid, {%{}, %{}}, fn {{x, y}, value}, {left_grid, right_grid} ->
        if x < fold_x do
          {Map.put(left_grid, {x, y}, value), right_grid}
        else
          {left_grid, Map.put(right_grid, {x, y}, value)}
        end
      end)

    right_ones =
      right_grid
      |> Enum.filter(fn {{_x, _y}, value} -> value == @filled_cell end)
      # re-calculate coordinates
      |> Enum.map(fn {{x, y}, value} ->
        {{abs(x - 2 * fold_x), y}, value}
      end)
      |> Map.new()

    Map.merge(left_grid, right_ones)
  end

  defp preprocess_input(input) do
    [coords, instructions] =
      input
      |> String.split("\n\n", trim: true)

    parsed_ones =
      coords
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.reduce(%{}, fn [x, y], acc ->
        Map.put(acc, {String.to_integer(x), String.to_integer(y)}, @filled_cell)
      end)

    max_x = Enum.max_by(parsed_ones, fn {{x, _y}, _v} -> x end) |> elem(0) |> elem(0)
    max_y = Enum.max_by(parsed_ones, fn {{_x, y}, _v} -> y end) |> elem(0) |> elem(1)

    empty_grid =
      for row <- 0..max_x,
          col <- 0..max_y,
          into: %{} do
        {{row, col}, @empty_cell}
      end

    parsed_grid = Map.merge(empty_grid, parsed_ones)

    parsed_instructions =
      instructions
      |> String.replace("fold along ", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "=", trim: true))
      |> Enum.map(fn [axis, value] -> {axis, String.to_integer(value)} end)

    {parsed_grid, parsed_instructions}
  end

  defp print_grid(grid, sep \\ "") do
    grid
    |> Enum.group_by(fn {{_x, y}, _value} -> y end)
    |> Enum.map(fn {_y, points} ->
      Enum.map(points, fn {{x, _y}, value} -> {x, value} end)
      |> Enum.sort(fn {x1, _}, {x2, _} -> x1 < x2 end)
      |> Enum.map(fn {_x, v} -> v end)
      |> Enum.join(sep)
    end)
    |> Enum.each(fn l -> IO.puts(l) end)

    IO.puts("\n")

    grid
  end
end
