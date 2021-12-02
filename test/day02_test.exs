defmodule AdventOfCode.Day02.P1Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d02.txt")

      assert AdventOfCode.Day02.part1(input) == 150
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d02.txt")

      assert AdventOfCode.Day02.part2(input) == 900
    end
  end
end
