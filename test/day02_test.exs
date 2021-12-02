defmodule AdventOfCode.Day02.P1Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = "
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    "

      assert AdventOfCode.Day02.part1(input) == 150
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = "
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    "

      assert AdventOfCode.Day02.part2(input) == 900
    end
  end
end
