defmodule AdventOfCode.Day01.P1Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = "
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    "

      assert AdventOfCode.Day01.part1(input) == 7
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = "
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    "

      assert AdventOfCode.Day01.part2(input) == 5
    end
  end
end
