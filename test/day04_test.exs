defmodule AdventOfCode.Day04Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d04.txt")

      assert AdventOfCode.Day04.part1(input) == 4512
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d04.txt")

      assert AdventOfCode.Day04.part2(input) == 1924
    end
  end
end
