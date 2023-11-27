defmodule PvStructureTest do
  use ExUnit.Case

  @example_fields [
    %Epics.PvStructure{
      name: "value",
      type: "string",
      introspection_id: nil,
      fields: nil
    },
    %Epics.PvStructure{
      name: "display",
      type: "structure",
      introspection_id: 4,
      fields: [
        %Epics.PvStructure{
          name: "limitLow",
          type: "double",
          introspection_id: nil,
          fields: nil
        },
        %Epics.PvStructure{
          name: "limitHigh",
          type: "double",
          introspection_id: nil,
          fields: nil
        },
        %Epics.PvStructure{
          name: "form",
          type: "enum_t",
          introspection_id: 5,
          fields: [
            %Epics.PvStructure{
              name: "index",
              type: "int",
              introspection_id: nil,
              fields: nil
            },
            %Epics.PvStructure{
              name: "choices",
              type: "string[]",
              introspection_id: nil,
              fields: nil
            }
          ]
        }]}]

  test "can create PvStructure" do
    result = Epics.PvStructure.create("strvalue", "string", 123, @example_fields, "hello")

    assert result.name == "strvalue"
    assert result.type == "string"
    assert result.introspection_id == 123
    assert result.fields == @example_fields
    assert result.value == "hello"
  end

  test "can access top-level field by name" do
    structure = Epics.PvStructure.create("strvalue", "string", 123, @example_fields)

    result = Epics.PvStructure.get_field(structure, "display")

    assert result.name == "display"
    assert result.type == "structure"
    assert result.introspection_id == 4
    refute result.fields == nil
  end
end
