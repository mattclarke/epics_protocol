defmodule EpicsProtocolTest do
  use ExUnit.Case
  doctest EpicsProtocol

  test "greets the world" do
    assert EpicsProtocol.hello() == :world
  end
end
