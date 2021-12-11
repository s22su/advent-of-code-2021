defmodule AdventOfCode.Day10Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d10.txt")

      assert AdventOfCode.Day10.part1(input) == 26397
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d10.txt")

      assert AdventOfCode.Day10.part2(input) == 288_957
    end
  end
end
