defmodule AdventOfCode.Day12Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d12.txt")

      assert AdventOfCode.Day12.part1(input) == 10
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d12.txt")

      assert AdventOfCode.Day12.part2(input) == 36
    end
  end
end
