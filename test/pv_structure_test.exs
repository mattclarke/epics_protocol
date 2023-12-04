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
        }
      ]
    }
  ]

  test "can create PvStructure" do
    result = Epics.PvStructure.create("strvalue", "structure", 0, @example_fields)

    assert result.name == "strvalue"
    assert result.type == "structure"
    assert result.introspection_id == 0
    assert result.fields == @example_fields
  end

  test "can access top-level field by name" do
    structure = Epics.PvStructure.create("strvalue", "structure", 0, @example_fields)

    result = Epics.PvStructure.get_field(structure, "display")

    assert result.name == "display"
    assert result.type == "structure"
    assert result.introspection_id == 4
    refute result.fields == nil
  end

  test "if field doesn't exist then returns nil" do
    structure = Epics.PvStructure.create("strvalue", "structure", 0, @example_fields)

    assert Epics.PvStructure.get_field(structure, "does not exist") == nil
  end

  test "can access non top level field by name" do
    structure = Epics.PvStructure.create("strvalue", "structure", 0, @example_fields)

    display = Epics.PvStructure.get_field(structure, "display")
    result = Epics.PvStructure.get_field(display, "limitLow")

    assert result.name == "limitLow"
    assert result.type == "double"
    assert result.introspection_id == nil
    assert result.fields == nil
  end

  test "flatten gets the value fields 'paths' in order" do
    structure = Epics.PvStructure.create("strvalue", "structure", 0, @example_fields)

    result = Epics.PvStructure.get_value_paths_in_order(structure)

    assert Enum.at(result, 0) == ["value"]
    assert Enum.at(result, 1) == ["display", "limitLow"]
    assert Enum.at(result, 2) == ["display", "limitHigh"]
    assert Enum.at(result, 3) == ["display", "form", "index"]
    assert Enum.at(result, 4) == ["display", "form", "choices"]
  end

  test "can access non top level field by path" do
    structure = Epics.PvStructure.create("strvalue", "structure", 0, @example_fields)

    result = Epics.PvStructure.get_field_from_path(structure, ["display", "form", "choices"])

    assert result.name == "choices"
    assert result.type == "string[]"
    assert result.introspection_id == nil
    assert result.fields == nil
  end
end
