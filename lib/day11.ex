defmodule AdventOfCode.Day11 do
  @moduledoc false
  use AdventOfCode

  defmodule Point, do: defstruct(value: nil, coordinates: nil, neighbors: [])

  def part1(input), do: preprocess_input(input) |> step(0, 99) |> elem(1)

  def part2(input, grid \\ nil, current_step \\ 0) do
    grid =
      (grid || preprocess_input(input))
      |> step(0, 0)
      |> elem(0)

    all_zeros = Enum.map(grid, fn {_, %Point{value: value}} -> value end) |> Enum.all?(&(&1 == 0))

    if all_zeros, do: current_step + 1, else: part2(nil, grid, current_step + 1)
  end

  defp step(grid, total_flashes, steps_left) do
    # add +1 to all values
    grid =
      Enum.map(grid, fn {k, %Point{value: value} = point} ->
        new_value = value + 1

        {k, %{point | value: new_value}}
      end)
      |> Map.new()
      # add + 1 to all neighbors
      |> find_and_update_neighbors()

    # count how many octopuses flashed
    count_flashes = Enum.filter(grid, fn {_c, %Point{value: v}} -> v > 9 end) |> Enum.count()
    new_total_flashes = total_flashes + count_flashes

    # update all flashed octopuses energy to 0
    grid =
      Enum.map(grid, fn {coordinates, %Point{value: value} = point} ->
        if value > 9 do
          {coordinates, %{point | value: 0}}
        else
          {coordinates, point}
        end
      end)
      |> Map.new()

    if steps_left == 0,
      do: {grid, new_total_flashes},
      else: step(grid, new_total_flashes, steps_left - 1)
  end

  defp find_and_update_neighbors(grid) do
    flashing_neighbors =
      grid
      |> Enum.filter(fn {_c, %Point{value: v}} -> v == 10 end)
      |> Enum.map(fn {_, %Point{coordinates: coordinates, value: _value, neighbors: neighbors}} ->
        [coordinates | neighbors]
      end)
      |> List.flatten()

    grid =
      Enum.map(grid, fn {k, %Point{value: value} = point} ->
        # update all 10s by one so we won't count them again
        new_value = if value == 10, do: value + 1, else: value

        {k, %{point | value: new_value}}
      end)
      |> Map.new()

    if Enum.empty?(flashing_neighbors),
      do: grid,
      else: update_neighbors(grid, flashing_neighbors)
  end

  defp update_neighbors(grid, neighbors) do
    Enum.reduce(neighbors, grid, fn neighbor_coordinates, acc ->
      %Point{value: value} = point = Map.get(acc, neighbor_coordinates)

      # don't update 10s as they are not counted as flashed yet
      new_value = if value == 10, do: value, else: value + 1

      Map.put(acc, neighbor_coordinates, %{point | value: new_value})
    end)
    |> find_and_update_neighbors()
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
      {coordinates, %{point | neighbors: find_neighbors(grid, point)}}
    end)
    |> Map.new()
  end

  defp find_neighbors(grid, %Point{coordinates: {x, y}}) do
    neighbor_coordinates = [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y + 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y - 1}
    ]

    Enum.filter(grid, fn {coordinates, _} -> Enum.member?(neighbor_coordinates, coordinates) end)
    |> Enum.map(fn {coordinates, _} -> coordinates end)
  end

  # defp print_grid(grid, sep \\ "") do
  #   grid
  #   |> Enum.group_by(fn {{_x, y}, %Point{} = _point} -> y end)
  #   |> Enum.map(fn {_y, points} ->
  #     Enum.map(points, fn {_, %Point{coordinates: {x, _y}, value: value}} -> {x, value} end)
  #     |> Enum.sort(fn {x1, _}, {x2, _} -> x1 < x2 end)
  #     |> Enum.map(fn {_x, v} -> v end)
  #     |> Enum.join(sep)
  #   end)
  #   |> Enum.each(fn l -> IO.puts(l) end)

  #   IO.puts("\n")

  #   grid
  # end
end
