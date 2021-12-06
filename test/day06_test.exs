defmodule AdventOfCode.Day06Test do
  use ExUnit.Case, async: true

  describe "part1/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d06.txt")

      assert AdventOfCode.Day06.part1(input) == 5934
    end
  end

  describe "part2/1" do
    test "solves the puzzle" do
      input = File.read!("test/input_data/d06.txt")

      assert AdventOfCode.Day06.part2(input) == 26_984_457_539
    end
  end
end
