defmodule GetCommandTest do
  use ExUnit.Case

  @expected_string_structure %Epics.PvStructure{
    name: "epics:nt/NTScalar:1.0",
    type: "structure",
    introspection_id: 1,
    fields: [
      %Epics.PvStructure{
        name: "value",
        type: :string,
        introspection_id: nil,
        fields: nil
      },
      %Epics.PvStructure{
        name: "alarm",
        type: "alarm_t",
        introspection_id: 2,
        fields: [
          %Epics.PvStructure{
            name: "severity",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "status",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "message",
            type: :string,
            introspection_id: nil,
            fields: nil
          }
        ]
      },
      %Epics.PvStructure{
        name: "timeStamp",
        type: "structure",
        introspection_id: 3,
        fields: [
          %Epics.PvStructure{
            name: "secondsPastEpoch",
            type: :long,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "nanoseconds",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "userTag",
            type: :int,
            introspection_id: nil,
            fields: nil
          }
        ]
      },
      %Epics.PvStructure{
        name: "display",
        type: "structure",
        introspection_id: 4,
        fields: [
          %Epics.PvStructure{
            name: "limitLow",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "limitHigh",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "description",
            type: :string,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "units",
            type: :string,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "precision",
            type: :int,
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
                type: :int,
                introspection_id: nil,
                fields: nil
              },
              %Epics.PvStructure{
                name: "choices",
                type: :string_array,
                introspection_id: nil,
                fields: nil
              }
            ]
          }
        ]
      },
      %Epics.PvStructure{
        name: "control",
        type: "control_t",
        introspection_id: 6,
        fields: [
          %Epics.PvStructure{
            name: "limitLow",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "limitHigh",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "minStep",
            type: :double,
            introspection_id: nil,
            fields: nil
          }
        ]
      }
    ]
  }

  @expected_ai_structure %Epics.PvStructure{
    name: "epics:nt/NTScalar:1.0",
    type: "structure",
    introspection_id: 1,
    fields: [
      %Epics.PvStructure{
        name: "value",
        type: :double,
        introspection_id: nil,
        fields: nil
      },
      %Epics.PvStructure{
        name: "alarm",
        type: "alarm_t",
        introspection_id: 2,
        fields: [
          %Epics.PvStructure{
            name: "severity",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "status",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "message",
            type: :string,
            introspection_id: nil,
            fields: nil
          }
        ]
      },
      %Epics.PvStructure{
        name: "timeStamp",
        type: "structure",
        introspection_id: 3,
        fields: [
          %Epics.PvStructure{
            name: "secondsPastEpoch",
            type: :long,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "nanoseconds",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "userTag",
            type: :int,
            introspection_id: nil,
            fields: nil
          }
        ]
      },
      %Epics.PvStructure{
        name: "display",
        type: "structure",
        introspection_id: 4,
        fields: [
          %Epics.PvStructure{
            name: "limitLow",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "limitHigh",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "description",
            type: :string,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "units",
            type: :string,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "precision",
            type: :int,
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
                type: :int,
                introspection_id: nil,
                fields: nil
              },
              %Epics.PvStructure{
                name: "choices",
                type: :string_array,
                introspection_id: nil,
                fields: nil
              }
            ]
          }
        ]
      },
      %Epics.PvStructure{
        name: "control",
        type: "control_t",
        introspection_id: 6,
        fields: [
          %Epics.PvStructure{
            name: "limitLow",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "limitHigh",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "minStep",
            type: :double,
            introspection_id: nil,
            fields: nil
          }
        ]
      },
      %Epics.PvStructure{
        name: "valueAlarm",
        type: "valueAlarm_t",
        introspection_id: 7,
        fields: [
          %Epics.PvStructure{
            name: "active",
            type: :boolean,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "lowAlarmLimit",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "lowWarningLimit",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "highWarningLimit",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "highAlarmLimit",
            type: :double,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "lowAlarmSeverity",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "lowWarningSeverity",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "highWarningSeverity",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "highAlarmSeverity",
            type: :int,
            introspection_id: nil,
            fields: nil
          },
          %Epics.PvStructure{
            name: "hysteresis",
            type: :byte,
            introspection_id: nil,
            fields: nil
          }
        ]
      }
    ]
  }

  test "decode channelGetResponseInit for stringin" do
    binary_response =
      <<202, 2, 64, 10, 38, 1, 0, 0, 57, 48, 0, 0, 8, 255, 253, 1, 0, 128, 21, 101, 112, 105, 99,
        115, 58, 110, 116, 47, 78, 84, 83, 99, 97, 108, 97, 114, 58, 49, 46, 48, 5, 5, 118, 97,
        108, 117, 101, 96, 5, 97, 108, 97, 114, 109, 253, 2, 0, 128, 7, 97, 108, 97, 114, 109, 95,
        116, 3, 8, 115, 101, 118, 101, 114, 105, 116, 121, 34, 6, 115, 116, 97, 116, 117, 115, 34,
        7, 109, 101, 115, 115, 97, 103, 101, 96, 9, 116, 105, 109, 101, 83, 116, 97, 109, 112,
        253, 3, 0, 128, 0, 3, 16, 115, 101, 99, 111, 110, 100, 115, 80, 97, 115, 116, 69, 112,
        111, 99, 104, 35, 11, 110, 97, 110, 111, 115, 101, 99, 111, 110, 100, 115, 34, 7, 117,
        115, 101, 114, 84, 97, 103, 34, 7, 100, 105, 115, 112, 108, 97, 121, 253, 4, 0, 128, 0, 6,
        8, 108, 105, 109, 105, 116, 76, 111, 119, 67, 9, 108, 105, 109, 105, 116, 72, 105, 103,
        104, 67, 11, 100, 101, 115, 99, 114, 105, 112, 116, 105, 111, 110, 96, 5, 117, 110, 105,
        116, 115, 96, 9, 112, 114, 101, 99, 105, 115, 105, 111, 110, 34, 4, 102, 111, 114, 109,
        253, 5, 0, 128, 6, 101, 110, 117, 109, 95, 116, 2, 5, 105, 110, 100, 101, 120, 34, 7, 99,
        104, 111, 105, 99, 101, 115, 104, 7, 99, 111, 110, 116, 114, 111, 108, 253, 6, 0, 128, 9,
        99, 111, 110, 116, 114, 111, 108, 95, 116, 3, 8, 108, 105, 109, 105, 116, 76, 111, 119,
        67, 9, 108, 105, 109, 105, 116, 72, 105, 103, 104, 67, 7, 109, 105, 110, 83, 116, 101,
        112, 67>>

    {:ok, result} = Epics.GetCommand.decode_channel_get_response_init(binary_response)

    assert result.request_id == 12345
    assert result.status == :ok

    assert result.fields == @expected_string_structure
  end

  test "returns error if header isn't correct" do
    # Manually changed the command byte from 10 to 11
    binary_response =
      <<202, 2, 64, 11, 231, 1, 0, 0, 57, 48, 0, 0, 8, 255, 253, 1, 0, 128, 21, 101, 112, 105, 99,
        115, 58, 110, 116, 47, 78, 84, 83, 99, 97, 108, 97, 114, 58, 49, 46, 48, 6, 5, 118, 97,
        108, 117, 101, 67, 5, 97, 108, 97, 114, 109, 253, 2, 0, 128, 7, 97, 108, 97, 114, 109, 95,
        116, 3, 8, 115, 101, 118, 101, 114, 105, 116, 121, 34, 6, 115, 116, 97, 116, 117, 115, 34,
        7, 109, 101, 115, 115, 97, 103, 101, 96, 9, 116, 105, 109, 101, 83, 116, 97, 109, 112,
        253, 3, 0, 128, 0, 3, 16, 115, 101, 99, 111, 110, 100, 115, 80, 97, 115, 116, 69, 112,
        111, 99, 104, 35, 11, 110, 97, 110, 111, 115, 101, 99, 111, 110, 100, 115, 34, 7, 117,
        115, 101, 114, 84, 97, 103, 34, 7, 100, 105, 115, 112, 108, 97, 121, 253, 4, 0, 128, 0, 6,
        8, 108, 105, 109, 105, 116, 76, 111, 119, 67, 9, 108, 105, 109, 105, 116, 72, 105, 103,
        104, 67, 11, 100, 101, 115, 99, 114, 105, 112, 116, 105, 111, 110, 96, 5, 117, 110, 105,
        116, 115, 96, 9, 112, 114, 101, 99, 105, 115, 105, 111, 110, 34, 4, 102, 111, 114, 109,
        253, 5, 0, 128, 6, 101, 110, 117, 109, 95, 116, 2, 5, 105, 110, 100, 101, 120, 34, 7, 99,
        104, 111, 105, 99, 101, 115, 104, 7, 99, 111, 110, 116, 114, 111, 108, 253, 6, 0, 128, 9,
        99, 111, 110, 116, 114, 111, 108, 95, 116, 3, 8, 108, 105, 109, 105, 116, 76, 111, 119,
        67, 9, 108, 105, 109, 105, 116, 72, 105, 103, 104, 67, 7, 109, 105, 110, 83, 116, 101,
        112, 67, 10, 118, 97, 108, 117, 101, 65, 108, 97, 114, 109, 253, 7, 0, 128, 12, 118, 97,
        108, 117, 101, 65, 108, 97, 114, 109, 95, 116, 10, 6, 97, 99, 116, 105, 118, 101, 0, 13,
        108, 111, 119, 65, 108, 97, 114, 109, 76, 105, 109, 105, 116, 67, 15, 108, 111, 119, 87,
        97, 114, 110, 105, 110, 103, 76, 105, 109, 105, 116, 67, 16, 104, 105, 103, 104, 87, 97,
        114, 110, 105, 110, 103, 76, 105, 109, 105, 116, 67, 14, 104, 105, 103, 104, 65, 108, 97,
        114, 109, 76, 105, 109, 105, 116, 67, 16, 108, 111, 119, 65, 108, 97, 114, 109, 83, 101,
        118, 101, 114, 105, 116, 121, 34, 18, 108, 111, 119, 87, 97, 114, 110, 105, 110, 103, 83,
        101, 118, 101, 114, 105, 116, 121, 34, 19, 104, 105, 103, 104, 87, 97, 114, 110, 105, 110,
        103, 83, 101, 118, 101, 114, 105, 116, 121, 34, 17, 104, 105, 103, 104, 65, 108, 97, 114,
        109, 83, 101, 118, 101, 114, 105, 116, 121, 34, 10, 104, 121, 115, 116, 101, 114, 101,
        115, 105, 115, 32>>

    {:error, message} = Epics.GetCommand.decode_channel_get_response_init(binary_response)
  end

  test "if status is not ok or warning" do
  end

  test "decode channelGetResponse for stringin" do
    binary_response =
      <<202, 2, 64, 10, 151, 0, 0, 0, 57, 48, 0, 0, 0, 255, 1, 1, 5, 72, 101, 108, 108, 111, 0, 0,
        0, 0, 2, 0, 0, 0, 3, 85, 68, 70, 128, 157, 158, 37, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 68, 101,
        102, 97, 117, 108, 116, 6, 83, 116, 114, 105, 110, 103, 6, 66, 105, 110, 97, 114, 121, 7,
        68, 101, 99, 105, 109, 97, 108, 3, 72, 101, 120, 11, 69, 120, 112, 111, 110, 101, 110,
        116, 105, 97, 108, 11, 69, 110, 103, 105, 110, 101, 101, 114, 105, 110, 103, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>

    {:ok, result} =
      Epics.GetCommand.decode_channel_get_response(@expected_string_structure, binary_response)

    assert result.request_id == 12345
    assert result.status == :ok
    assert Map.get(result.values, ["value"]) == "Hello"
    assert Map.get(result.values, ["alarm", "severity"]) == 0
    assert Map.get(result.values, ["alarm", "status"]) == 2
    assert Map.get(result.values, ["alarm", "message"]) == "UDF"
    assert Map.get(result.values, ["timeStamp", "secondsPastEpoch"]) == 631_152_000
    assert Map.get(result.values, ["timeStamp", "nanoseconds"]) == 0
    assert Map.get(result.values, ["timeStamp", "userTag"]) == 0
    assert Map.get(result.values, ["display", "limitLow"]) == 0
    assert Map.get(result.values, ["display", "limitHigh"]) == 0
    assert Map.get(result.values, ["display", "description"]) == ""
    assert Map.get(result.values, ["display", "units"]) == ""
    assert Map.get(result.values, ["display", "precision"]) == 0
    assert Map.get(result.values, ["display", "form", "index"]) == 0

    assert Map.get(result.values, ["display", "form", "choices"]) ==
             {"Default", "String", "Binary", "Decimal", "Hex", "Exponential", "Engineering"}

    assert Map.get(result.values, ["control", "limitLow"]) == 0
    assert Map.get(result.values, ["control", "limitHigh"]) == 0
    assert Map.get(result.values, ["control", "minStep"]) == 0
  end

  test "decode channelGetResponseInit for ai" do
    binary_response =
      <<202, 2, 64, 10, 231, 1, 0, 0, 57, 48, 0, 0, 8, 255, 253, 1, 0, 128, 21, 101, 112, 105, 99,
        115, 58, 110, 116, 47, 78, 84, 83, 99, 97, 108, 97, 114, 58, 49, 46, 48, 6, 5, 118, 97,
        108, 117, 101, 67, 5, 97, 108, 97, 114, 109, 253, 2, 0, 128, 7, 97, 108, 97, 114, 109, 95,
        116, 3, 8, 115, 101, 118, 101, 114, 105, 116, 121, 34, 6, 115, 116, 97, 116, 117, 115, 34,
        7, 109, 101, 115, 115, 97, 103, 101, 96, 9, 116, 105, 109, 101, 83, 116, 97, 109, 112,
        253, 3, 0, 128, 0, 3, 16, 115, 101, 99, 111, 110, 100, 115, 80, 97, 115, 116, 69, 112,
        111, 99, 104, 35, 11, 110, 97, 110, 111, 115, 101, 99, 111, 110, 100, 115, 34, 7, 117,
        115, 101, 114, 84, 97, 103, 34, 7, 100, 105, 115, 112, 108, 97, 121, 253, 4, 0, 128, 0, 6,
        8, 108, 105, 109, 105, 116, 76, 111, 119, 67, 9, 108, 105, 109, 105, 116, 72, 105, 103,
        104, 67, 11, 100, 101, 115, 99, 114, 105, 112, 116, 105, 111, 110, 96, 5, 117, 110, 105,
        116, 115, 96, 9, 112, 114, 101, 99, 105, 115, 105, 111, 110, 34, 4, 102, 111, 114, 109,
        253, 5, 0, 128, 6, 101, 110, 117, 109, 95, 116, 2, 5, 105, 110, 100, 101, 120, 34, 7, 99,
        104, 111, 105, 99, 101, 115, 104, 7, 99, 111, 110, 116, 114, 111, 108, 253, 6, 0, 128, 9,
        99, 111, 110, 116, 114, 111, 108, 95, 116, 3, 8, 108, 105, 109, 105, 116, 76, 111, 119,
        67, 9, 108, 105, 109, 105, 116, 72, 105, 103, 104, 67, 7, 109, 105, 110, 83, 116, 101,
        112, 67, 10, 118, 97, 108, 117, 101, 65, 108, 97, 114, 109, 253, 7, 0, 128, 12, 118, 97,
        108, 117, 101, 65, 108, 97, 114, 109, 95, 116, 10, 6, 97, 99, 116, 105, 118, 101, 0, 13,
        108, 111, 119, 65, 108, 97, 114, 109, 76, 105, 109, 105, 116, 67, 15, 108, 111, 119, 87,
        97, 114, 110, 105, 110, 103, 76, 105, 109, 105, 116, 67, 16, 104, 105, 103, 104, 87, 97,
        114, 110, 105, 110, 103, 76, 105, 109, 105, 116, 67, 14, 104, 105, 103, 104, 65, 108, 97,
        114, 109, 76, 105, 109, 105, 116, 67, 16, 108, 111, 119, 65, 108, 97, 114, 109, 83, 101,
        118, 101, 114, 105, 116, 121, 34, 18, 108, 111, 119, 87, 97, 114, 110, 105, 110, 103, 83,
        101, 118, 101, 114, 105, 116, 121, 34, 19, 104, 105, 103, 104, 87, 97, 114, 110, 105, 110,
        103, 83, 101, 118, 101, 114, 105, 116, 121, 34, 17, 104, 105, 103, 104, 65, 108, 97, 114,
        109, 83, 101, 118, 101, 114, 105, 116, 121, 34, 10, 104, 121, 115, 116, 101, 114, 101,
        115, 105, 115, 32>>

    {:ok, result} = Epics.GetCommand.decode_channel_get_response_init(binary_response)

    assert result.request_id == 12345
    assert result.status == :ok

    assert result.fields == @expected_ai_structure
  end

  test "decode channelGetResponse for ai" do
    binary_response =
      <<202, 2, 64, 10, 203, 0, 0, 0, 57, 48, 0, 0, 0, 255, 1, 1, 88, 57, 180, 200, 118, 190, 243,
        63, 1, 0, 0, 0, 1, 0, 0, 0, 3, 76, 79, 87, 23, 124, 110, 101, 0, 0, 0, 0, 112, 219, 181,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 7, 7, 68, 101, 102, 97, 117, 108, 116, 6, 83, 116, 114, 105, 110, 103, 6, 66, 105, 110,
        97, 114, 121, 7, 68, 101, 99, 105, 109, 97, 108, 3, 72, 101, 120, 11, 69, 120, 112, 111,
        110, 101, 110, 116, 105, 97, 108, 11, 69, 110, 103, 105, 110, 101, 101, 114, 105, 110,
        103, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 50, 64, 0, 0, 0, 0, 0, 0, 52,
        64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>

    {:ok, result} =
      Epics.GetCommand.decode_channel_get_response(@expected_ai_structure, binary_response)

    assert result.request_id == 12345
    assert result.status == :ok
    assert Map.get(result.values, ["value"]) == 1.234
    assert Map.get(result.values, ["alarm", "severity"]) == 1
    assert Map.get(result.values, ["alarm", "status"]) == 1
    assert Map.get(result.values, ["alarm", "message"]) == "LOW"
    assert Map.get(result.values, ["timeStamp", "secondsPastEpoch"]) == 1_701_739_543
    assert Map.get(result.values, ["timeStamp", "nanoseconds"]) == 230_022_000
    assert Map.get(result.values, ["timeStamp", "userTag"]) == 0
    assert Map.get(result.values, ["display", "limitLow"]) == 0
    assert Map.get(result.values, ["display", "limitHigh"]) == 0
    assert Map.get(result.values, ["display", "description"]) == ""
    assert Map.get(result.values, ["display", "units"]) == ""
    assert Map.get(result.values, ["display", "precision"]) == 0
    assert Map.get(result.values, ["display", "form", "index"]) == 0

    assert Map.get(result.values, ["display", "form", "choices"]) ==
             {"Default", "String", "Binary", "Decimal", "Hex", "Exponential", "Engineering"}

    assert Map.get(result.values, ["control", "limitLow"]) == 0
    assert Map.get(result.values, ["control", "limitHigh"]) == 0
    assert Map.get(result.values, ["control", "minStep"]) == 0
    assert Map.get(result.values, ["valueAlarm", "active"]) == false
    assert Map.get(result.values, ["valueAlarm", "lowAlarmLimit"]) == 0
    assert Map.get(result.values, ["valueAlarm", "lowWarningLimit"]) == 2
    assert Map.get(result.values, ["valueAlarm", "highAlarmLimit"]) == 20
    assert Map.get(result.values, ["valueAlarm", "highWarningLimit"]) == 18
    assert Map.get(result.values, ["valueAlarm", "lowAlarmSeverity"]) == 0
    assert Map.get(result.values, ["valueAlarm", "lowWarningSeverity"]) == 0
    assert Map.get(result.values, ["valueAlarm", "highAlarmSeverity"]) == 0
    assert Map.get(result.values, ["valueAlarm", "highWarningSeverity"]) == 0
    assert Map.get(result.values, ["valueAlarm", "hysteresis"]) == 0
  end
end
