defmodule AdventOfCode.Day08Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d08.txt")

      assert AdventOfCode.Day08.part1(input) == 26
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d08.txt")

      assert AdventOfCode.Day08.part2(input) == 61229
    end
  end
end
