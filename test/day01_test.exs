defmodule AdventOfCode.Day01Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d01.txt")

      assert AdventOfCode.Day01.part1(input) == 7
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d01.txt")

      assert AdventOfCode.Day01.part2(input) == 5
    end
  end
end
