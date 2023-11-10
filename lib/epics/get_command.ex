defmodule Epics.GetCommand do
  alias Epics.GetCommand
  defstruct [:flags, :request_id, :status, :introspection_id]

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
        << <<request_id::32-little>>, @init_cmd, status, rest::binary>> = payload
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
        <<0xFD, introspection_id::16-little, field_description, rest::binary>> = rest

        case field_description do
          128 ->
            # Structure: identification string + (field name, FieldDesc)[]
            << string_length, rest::binary >> = rest
            <<type_string::binary-size(string_length), rest::binary>> = rest
            IO.inspect(type_string)
        end


        {:ok, %GetCommand{flags: flags, request_id: request_id, status: status, introspection_id: introspection_id}}
      _ -> {:error, "Binary data does not conform to expected channelGetResponseInit format"}
    end

  end
end
