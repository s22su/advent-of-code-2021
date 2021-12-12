defmodule AdventOfCode.Day12 do
  @moduledoc false
  use AdventOfCode

  def part1(input) do
    preprocess_input(input)
    |> dfs("start", "end", [], [])
    |> Enum.count()
  end

  def part2(input) do
    preprocess_input(input)
    |> dfs2("start", "start", "end", [], %{}, [])
    |> Enum.count()
  end

  def dfs(graph, current_point, destination, visited, full_paths) do
    cond do
      current_point == destination ->
        visited = [current_point | visited]

        [visited | full_paths]

      lowercase?(current_point) && Enum.member?(visited, current_point) ->
        full_paths

      true ->
        next_points = graph[current_point] |> MapSet.to_list()

        visited = [current_point | visited]

        Enum.reduce(next_points, full_paths, fn next_point, acc_full_paths ->
          dfs(graph, next_point, destination, visited, acc_full_paths)
        end)
    end
  end

  def dfs2(graph, current_point, start_point, destination, visited, visited_small, full_paths) do
    cond do
      current_point == destination ->
        visited = [current_point | visited]

        [visited | full_paths]

      current_point == start_point && Enum.member?(visited, current_point) ->
        full_paths

      # Make sure to visit every lowercase point max 2 times and
      # make sure that all lowercase points can be visited
      lowercase?(current_point) && Enum.member?(Map.values(visited_small), 2) &&
          Enum.member?(Map.keys(visited_small), current_point) ->
        full_paths

      true ->
        next_points = graph[current_point] |> MapSet.to_list()

        visited = [current_point | visited]

        visited_small =
          if lowercase?(current_point) do
            count = (visited_small[current_point] || 0) + 1
            Map.put(visited_small, current_point, count)
          else
            visited_small
          end

        Enum.reduce(next_points, full_paths, fn next_point, acc_full_paths ->
          dfs2(
            graph,
            next_point,
            start_point,
            destination,
            visited,
            visited_small,
            acc_full_paths
          )
        end)
    end
  end

  defp lowercase?(char), do: char == String.downcase(char)

  defp preprocess_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.reduce(%{}, fn [p1, p2], acc ->
      acc
      |> Map.update(p1, MapSet.new([p2]), &MapSet.put(&1, p2))
      |> Map.update(p2, MapSet.new([p1]), &MapSet.put(&1, p1))
    end)
  end
end
