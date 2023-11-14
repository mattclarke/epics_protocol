defmodule Epics.GetCommand do
  alias Epics.GetCommand
  defstruct [:flags, :request_id, :status, :fields]

  @init_cmd 0x08

  def create_init_get_command(server_channel_id, request_id) do
    [
      # HEADER
      # Magic byte
      0xCA,
      # Version
      2,
      # Flags
      0,
      # Command
      0x0A,
      # Payload size in bytes (non-aligned)
      <<15::32-little>>,
      # PAYLOAD
      # serverChannelID
      <<server_channel_id::32-little>>,
      # requestID
      <<request_id::32-little>>,
      # subcommand
      @init_cmd,
      # FieldDesc
      0xFD,
      # Size?
      2,
      # ?
      0x00,
      # ?
      0x80,
      # ?
      0x00,
      # ?
      0x00
    ]
  end

  def decode_channel_get_response_init(data) do
    case data do
      <<0xCA, _version, flags, 0x0A, <<_payload_size::32-little>>, payload::binary>> ->
        <<(<<request_id::32-little>>), @init_cmd, status, rest::binary>> = payload
        # TODO: create status module as this is duplicated code
        status =
          case status do
            # Short-hand for OK and string fields omitted.
            255 -> :ok
            0 -> :ok
            1 -> :warning
            2 -> :error
            _ -> :fatal
          end

        # TODO: handle case when status is not 255 and we need to extract the string
        # TODO: don't decode the rest on error or fatal

        # starts with fd then introspection ID (unique short)
        <<0xFD, introspection_id::16-little, field_description, _rest::binary>> = rest

        {fields, _} =
          case field_description do
            128 ->
              decode_structure(rest)
          end

        {:ok, %GetCommand{flags: flags, request_id: request_id, status: status, fields: fields}}

      _ ->
        {:error, "Binary data does not conform to expected channelGetResponseInit format"}
    end
  end

  defp decode_structure(data) do
    <<0xFD, introspection_id::16-little, 128, rest::binary>> = data
    # Structure: identification string + (field name, FieldDesc)[]
    <<string_length, structure_name::binary-size(string_length), rest::binary>> = rest

    structure_name =
      case structure_name do
        "" -> "structure"
        _ -> structure_name
      end

    # Next byte defines the number of upper level fields
    <<num_fields, rest::binary>> = rest
    structure = %{"introspection_id" => introspection_id, "name" => structure_name}

    Enum.reduce(0..(num_fields - 1), {structure, rest}, fn _i, {acc, payload} ->
      {name, type, rest} = decode_name_and_type(payload)
      acc = Map.put(acc, name, type)
      {acc, rest}
    end)
  end

  defp decode_name_and_type(data) do
    # Name of field then type
    <<string_length, name::binary-size(string_length), rest::binary>> = data
    <<typecode, rest::binary>> = rest

    {type, rest} =
      case typecode do
        0x60 -> {"string", rest}
        0x22 -> {"int", rest}
        0x23 -> {"long", rest}
        0x43 -> {"double", rest}
        0x68 -> {"string[]", rest}
        0xFD -> decode_structure(<<typecode, rest::binary>>)
      end

    {name, type, rest}
  end
end
