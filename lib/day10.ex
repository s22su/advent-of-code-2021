defmodule AdventOfCode.Day10 do
  @moduledoc false
  use AdventOfCode

  def part1(input) do
    scores = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

    preprocess_input(input)
    |> Enum.map(fn command ->
      Enum.reduce_while(command, [], fn char, acc ->
        case check(char, acc) do
          {:ok, open_chars} ->
            {:cont, open_chars}

          {:error, _} ->
            {:halt, char}
        end
      end)
    end)
    |> Enum.reject(&is_list/1)
    |> Enum.map(&Map.get(scores, &1))
    |> Enum.sum()
  end

  def part2(input) do
    scores = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

    preprocess_input(input)
    |> Enum.map(fn command ->
      Enum.reduce_while(command, [], fn char, acc ->
        case check(char, acc) do
          {:ok, open_chars} ->
            {:cont, open_chars}

          {:error, _} ->
            {:halt, char}
        end
      end)
    end)
    |> Enum.reject(&is_binary/1)
    |> Enum.map(fn command ->
      Enum.reduce(command, [], &(&2 ++ [closing_char_for(&1)]))
      |> Enum.reduce(0, &(&2 * 5 + Map.get(scores, &1)))
    end)
    |> Enum.sort()
    |> Kernel.then(fn scores ->
      mid = (length(scores) / 2) |> floor()

      Enum.at(scores, mid)
    end)
  end

  defp check(")", ["(" | rest]), do: {:ok, rest}
  defp check("]", ["[" | rest]), do: {:ok, rest}
  defp check("}", ["{" | rest]), do: {:ok, rest}
  defp check(">", ["<" | rest]), do: {:ok, rest}

  defp check(char, open_chars) when char in ["(", "[", "{", "<"], do: {:ok, [char | open_chars]}

  defp check(_, open_chars), do: {:error, open_chars}

  defp closing_char_for("["), do: "]"
  defp closing_char_for("<"), do: ">"
  defp closing_char_for("("), do: ")"
  defp closing_char_for("{"), do: "}"

  defp preprocess_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split("")
      |> Enum.reject(&(&1 == ""))
    end)
  end
end
