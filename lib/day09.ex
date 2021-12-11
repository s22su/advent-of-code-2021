defmodule AdventOfCode.Day09 do
  @moduledoc false
  use AdventOfCode

  defmodule Point, do: defstruct(value: nil, coordinates: nil, neighbors: [])

  def part1(input) do
    grid = preprocess_input(input)

    Enum.reduce(grid, [], fn {_, %Point{neighbors: neighbors, value: value} = point}, acc ->
      neighbor_points = Enum.map(neighbors, &Map.get(grid, &1))

      if Enum.all?(neighbor_points, fn %Point{value: neighbor_value} -> value < neighbor_value end),
         do: [point | acc],
         else: acc
    end)
    |> Enum.map(fn %Point{value: value} -> value end)
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end

  def part2(input) do
    grid = preprocess_input(input)

    Enum.reduce(grid, [], fn {_, %Point{neighbors: neighbors, value: value} = point}, acc ->
      neighbor_points = Enum.map(neighbors, &Map.get(grid, &1))

      if Enum.all?(neighbor_points, fn %Point{value: neighbor_value} -> value < neighbor_value end),
         do: [point | acc],
         else: acc
    end)
    |> Enum.map(fn %Point{} = point -> find_basin_points(grid, point, []) end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp find_basin_points(grid, %Point{} = low_point, all_basin_points) do
    Enum.reduce(low_point.neighbors, all_basin_points, fn neighbor_coordinates, acc ->
      %Point{value: neighbor_value} = neighbor_point = Map.get(grid, neighbor_coordinates)

      if low_point.value < neighbor_value && neighbor_value != 9,
        do: find_basin_points(grid, neighbor_point, [low_point | acc]),
        else: [low_point | acc]
    end)
    |> Enum.uniq()
  end

  defp preprocess_input(input) do
    grid =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.trim()
        |> String.split("")
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {values, y}, acc ->
        values
        |> Enum.with_index()
        |> Enum.map(fn {value, x} ->
          {{x, y}, %Point{value: value, coordinates: {x, y}}}
        end)
        |> Map.new()
        |> Map.merge(acc)
      end)

    Enum.map(grid, fn {coordinates, %Point{} = point} ->
      {coordinates, Map.put(point, :neighbors, find_neighbors(grid, point))}
    end)
    |> Map.new()
  end

  defp find_neighbors(grid, %Point{coordinates: {x, y}}) do
    neighbor_coordinates = [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]

    Enum.filter(grid, fn {coordinates, _} -> Enum.member?(neighbor_coordinates, coordinates) end)
    |> Enum.map(fn {coordinates, _} -> coordinates end)
  end
end
