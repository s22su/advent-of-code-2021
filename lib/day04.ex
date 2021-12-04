defmodule AdventOfCode.Day04 do
  @moduledoc false
  use AdventOfCode

  def part1(input) do
    input |> preprocess_input() |> play()
  end

  def part2(input) do
    input |> preprocess_input() |> play2()
  end

  defp play({numbers, boards}) do
    {n, remaining_numbers} = draw_number(numbers)

    new_boards = Enum.map(boards, &mark_number(&1, n))
    winning_boards = Enum.filter(new_boards, &check_bingo/1)

    if length(winning_boards) == 0 do
      play({remaining_numbers, new_boards})
    else
      winning_boards
      |> List.flatten()
      |> Enum.filter(fn {_n, state} -> state == :o end)
      |> Enum.map(fn {n, _} -> n end)
      |> Enum.sum()
      |> (&(&1 * n)).()
    end
  end

  defp play2({numbers, boards}) do
    {n, remaining_numbers} = draw_number(numbers)

    new_boards = Enum.map(boards, &mark_number(&1, n))
    winning_boards = Enum.filter(new_boards, &check_bingo/1)

    new_boards =
      if length(winning_boards) > 0 && length(new_boards) > 1 do
        Enum.reject(new_boards, fn b ->
          Enum.member?(winning_boards, b)
        end)
      else
        new_boards
      end

    if new_boards !== winning_boards do
      play2({remaining_numbers, new_boards})
    else
      winning_boards
      |> List.flatten()
      |> Enum.filter(fn {_n, state} -> state == :o end)
      |> Enum.map(fn {n, _} -> n end)
      |> Enum.sum()
      |> (&(&1 * n)).()
    end
  end

  defp check_bingo(board) do
    line_win =
      board
      |> Enum.map(&check_bingo_line/1)
      |> Enum.any?()

    col_win =
      board
      |> transpose()
      |> Enum.map(&check_bingo_line/1)
      |> Enum.any?()

    line_win || col_win
  end

  defp check_bingo_line(line), do: Enum.all?(line, fn {_n, state} -> state == :x end)

  # https://stackoverflow.com/a/42887944/2328893
  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp mark_number(board, number) do
    Enum.map(board, fn line ->
      Enum.map(line, fn {n, _} = state -> if n == number, do: {n, :x}, else: state end)
    end)
  end

  defp draw_number([n | tail]), do: {n, tail}

  defp preprocess_input(input) do
    [numbers | rest] =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn el -> el !== "" end)

    {parse_numbers(numbers), parse_boards(rest)}
  end

  defp parse_boards(boards) do
    Enum.map(boards, fn line ->
      line
      |> String.split(" ")
      |> Enum.reject(fn n -> n == "" end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(fn n -> {n, :o} end)
    end)
    |> Enum.chunk_every(5)
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
