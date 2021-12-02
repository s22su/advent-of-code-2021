defmodule AdventOfCode do
  defmacro __using__(_) do
    quote do
      def part1() do
        __MODULE__
        |> to_string()
        |> String.replace("Elixir.AdventOfCode.Day", "")
        |> read_input()
        |> __MODULE__.part1()
      end

      def part2() do
        __MODULE__
        |> to_string()
        |> String.replace("Elixir.AdventOfCode.Day", "")
        |> read_input()
        |> __MODULE__.part2()
      end

      defp read_input(day) do
        {:ok, file} = File.read("input_data/d#{day}.txt")
        file
      end
    end
  end
end
