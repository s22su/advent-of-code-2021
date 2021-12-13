defmodule AdventOfCode.Day13Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d13.txt")

      assert AdventOfCode.Day13.part1(input) == 17
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d13.txt")

      AdventOfCode.Day13.part2(input)
    end
  end
end
