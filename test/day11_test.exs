defmodule AdventOfCode.Day11Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d11.txt")

      assert AdventOfCode.Day11.part1(input) == 1656
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d11.txt")

      assert AdventOfCode.Day11.part2(input) == 195
    end
  end
end
