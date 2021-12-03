defmodule AdventOfCode.Day03Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d03.txt")

      assert AdventOfCode.Day03.part1(input) == 198
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d03.txt")

      assert AdventOfCode.Day03.part2(input) == 230
    end
  end
end
