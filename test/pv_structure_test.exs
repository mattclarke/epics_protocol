defmodule PvStructureTest do
  use ExUnit.Case

  test "can create PvStructure" do
    result = Epics.PvStructure.create("alarm", "string", 123)

    assert result.name == "alarm"
    assert result.type == "string"
    assert result.introspection_id == 123
    assert result.fields == nil
  end
end
