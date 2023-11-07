defmodule Epics.Channel do
  defstruct [:flags, :client_channel_id, :server_channel_id, :status]

  def create_channel_request(pvname, channel_id) do
    payload_size = 2 + 4 + 1 + String.length(pvname)

    [
      # HEADER
      # Magic byte
      0xCA,
      # Version
      2,
      # Flags
      0,
      # Command
      7,
      # Payload size in bytes (non-aligned)
      <<payload_size::32-little>>,
      # PAYLOAD
      # count
      <<1::16-little>>,
      # struct
      # clientChannelID - must be unique to this connection
      <<channel_id::32-little>>,
      # String size
      String.length(pvname),
      # PV name
      pvname
    ]
  end

  def decode_create_channel_response(data, _channel_id) do
    case data do
      <<0xCA, _version, flags, 7, <<_payload_size::32-little>>, payload::binary>> ->
        <<(<<client_channel_id::32-little>>), <<server_channel_id::32-little>>, payload::binary>> =
          payload

        <<status, _payload::binary>> = payload

        status =
          case status do
            0 -> :ok
            # Short-hand for OK and string fields omitted.
            255 -> :ok
            1 -> :warning
            2 -> :error
            _ -> :fatal
          end

        {:ok,
         %Epics.Channel{
           flags: flags,
           client_channel_id: client_channel_id,
           server_channel_id: server_channel_id,
           status: status
         }}

      _ ->
        {:error, "Binary data does not conform to expected create channel response format"}
    end
  end
end
