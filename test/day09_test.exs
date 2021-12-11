defmodule AdventOfCode.Day09Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d09.txt")

      assert AdventOfCode.Day09.part1(input) == 15
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d09.txt")

      assert AdventOfCode.Day09.part2(input) == 1134
    end
  end
end
