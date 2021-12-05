defmodule AdventOfCode.Day05Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d05.txt")

      assert AdventOfCode.Day05.part1(input) == 5
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d05.txt")

      assert AdventOfCode.Day05.part2(input) == 12
    end
  end
end
