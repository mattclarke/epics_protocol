defmodule BitsetTest do
  use ExUnit.Case

  test "bitset to array" do
    [
      {<<0x00>>, []},
      {<<0x01>>, [0]},
      {<<0x02>>, [1]},
      {<<0x03>>, [0, 1]},
      {<<0x04>>, [2]},
      {<<0x05>>, [0, 2]},
      {<<0x06>>, [1, 2]},
      {<<0x07>>, [0, 1, 2]},
      {<<0x08>>, [3]},
      {<<0x09>>, [0, 3]},
      {<<0x0A>>, [1, 3]},
      {<<0x10>>, [4]},
      {<<0x20>>, [5]},
      {<<0x40>>, [6]},
      {<<0x80>>, [7]},
      {<<0xAA>>, [1, 3, 5, 7]}
    ]
    |> Enum.each(fn {bitset, expected} ->
      assert Epics.Bitset.to_array(bitset) == expected
    end)
  end

  test "multi byte bitset" do
    assert Epics.Bitset.to_array(<<0x00, 0x01>>) == [8]
    assert Epics.Bitset.to_array(<<0x00, 0x80>>) == [15]
    assert Epics.Bitset.to_array(<<0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80>>) == [55]

    assert Epics.Bitset.to_array(<<0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06>>) == [
             8,
             17,
             24,
             25,
             34,
             40,
             42,
             49,
             50
           ]
  end
end
