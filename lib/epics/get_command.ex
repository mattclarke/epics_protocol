defmodule Epics.GetCommand do
  alias Epics.GetCommand
  alias Epics.PvStructure
  defstruct [:flags, :request_id, :status, :fields, :values]

  @type epics_type :: :string | :int | :float | :long | :double | :string_array

  @init_cmd 0x08
  @get_cmd 0x00

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

    {fields, rest} =
      Enum.reduce(0..(num_fields - 1), {[], rest}, fn _i, {acc, payload} ->
        {type, rest} = decode_name_and_type(payload)
        {[type | acc], rest}
      end)

    {PvStructure.create(structure_name, "structure", introspection_id, Enum.reverse(fields)),
     rest}
  end

  defp decode_name_and_type(data) do
    # Name of field then type
    <<string_length, name::binary-size(string_length), rest::binary>> = data
    <<typecode, rest::binary>> = rest

    {type, rest} =
      case typecode do
        0x60 ->
          {PvStructure.create(name, :string), rest}

        0x22 ->
          {PvStructure.create(name, :int), rest}

        0x23 ->
          {PvStructure.create(name, :long), rest}

        0x43 ->
          {PvStructure.create(name, :double), rest}

        0x68 ->
          {PvStructure.create(name, :string_array), rest}

        0xFD ->
          {structure, rest} = decode_structure(<<typecode, rest::binary>>)
          # What is defined as the name is actually the type, so move the name to the type
          # And then insert the name defined above
          type = structure.name
          structure = %{structure | :name => name, :type => type}
          {structure, rest}
      end

    {type, rest}
  end

  def create_get_command(server_channel_id, request_id) do
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
      <<9::32-little>>,
      # PAYLOAD
      # serverChannelID
      <<server_channel_id::32-little>>,
      # requestID
      <<request_id::32-little>>,
      # subcommand
      @get_cmd
    ]
  end

  def decode_channel_get_response(structure, data) do
    case data do
      <<0xCA, _version, flags, 0x0A, <<_payload_size::32-little>>, payload::binary>> ->
        <<(<<request_id::32-little>>), @get_cmd, status, rest::binary>> = payload
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

        # Our example starts with 01 01 which is a bitset - this represents [0], that is to say all values
        # are included in the data (because it is the first get)
        # bitsets start with the size, then the "bits", e.g. 01 80 => length 1 + 00000001 => [7] as the 7th bit is 1
        # Another example: 02 17 (23 in dec) 01 => length 2 + 11101000 10000000 (LSB to MSB) => [0, 1, 2, 4, 8]
        <<bitset_length, bitset::binary-size(bitset_length), rest::binary>> = rest
        changes = Epics.Bitset.to_array(bitset)
        IO.inspect(changes)

        value_paths = Epics.PvStructure.get_value_paths_in_order(structure)
        value_structure = Epics.PvStructure.get_field_from_path(structure, hd(value_paths))
        IO.inspect(value_structure)

        {value, rest} =
          case value_structure.type do
            "string" ->
              <<string_length, value::binary-size(string_length), rest::binary>> = rest
              {value, rest}
          end

        values = %{hd(value_paths) => value}

        {:ok, %GetCommand{flags: flags, request_id: request_id, status: status, values: values}}

      _ ->
        {:error, "Binary data does not conform to expected channelGetResponseInit format"}
    end
  end
end
