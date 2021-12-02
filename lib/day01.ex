defmodule AdventOfCode.Day01 do
  @moduledoc false
  use AdventOfCode

  def part1(input) do
    preprocess_input(input)
    |> calc_increases()
  end

  def part2(input) do
    preprocess_input(input)
    |> calc_windows()
    |> Enum.with_index()
    |> calc_increases()
  end

  defp calc_increases(inp) do
    Enum.reduce(inp, 0, fn {num, i}, acc ->
      case i do
        0 ->
          acc

        _ ->
          prev_num = next_num_after_i_or_nil(inp, i, -1)

          if num > prev_num do
            acc + 1
          else
            acc
          end
      end
    end)
  end

  defp calc_windows(inp) do
    Enum.map(inp, fn {num, i} ->
      next_num1 = next_num_after_i_or_nil(inp, i, 1)
      next_num2 = next_num_after_i_or_nil(inp, i, 2)

      if next_num1 && next_num2, do: num + next_num1 + next_num2
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp next_num_after_i_or_nil(inp, curr_i, step_next) do
    case Enum.at(inp, curr_i + step_next) do
      nil -> nil
      n -> elem(n, 0)
    end
  end

  defp preprocess_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn el -> el !== "" end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end
end
