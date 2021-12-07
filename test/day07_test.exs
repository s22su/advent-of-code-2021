defmodule AdventOfCode.Day07Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d07.txt")

      assert AdventOfCode.Day07.part1(input) == 37
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d07.txt")

      assert AdventOfCode.Day07.part2(input) == 168
    end
  end
end
