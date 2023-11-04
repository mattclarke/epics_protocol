defmodule Epics.Protocol do
  def create_search_message(reply_port, pv_name) do
    payload_size = 38 + String.length(pv_name)

    [
      # HEADER
      # Magic byte
      0xCA,
      # Version
      2,
      # Flags
      0,
      # Command
      3,
      # Payload size in bytes (non-aligned)
      <<payload_size::32-little>>,
      # PAYLOAD
      # Search sequence ID
      <<456::32-little>>,
      # Flags
      0,
      # Reserved
      0,
      # Reserved
      0,
      # Reserved
      0,
      # Reponse address (16 bytes)
      <<0::32-little>>,
      <<0::32-little>>,
      <<0::16-little>>,
      0xFF,
      0xFF,
      # IP address
      0,
      # IP address
      0,
      # IP address
      0,
      # IP address
      0,
      # Port
      <<reply_port::16-little>>,
      # Num items in protocol array
      1,
      # Size of string array
      3,
      # Protocol
      "tcp",
      # Num channels
      <<1::16-little>>,
      # Search instance ID
      <<12345::32-little>>,
      # Size of channel name
      13,
      # Channel name
      pv_name
    ]
  end

  def decode_search_response({_ip, _port, data} = _reply) do
    # TODO: write tests for this whole function

    case data do
      <<0xCA, _version, _flags, 4, <<_payload_size::32-little>>, payload::binary>> ->
        <<(<<guid::96-little>>), <<search_seq_id::32-little>>, <<server_address::128-little>>,
          <<server_port::16-little>>, <<protocol_length::8-little>>, rest::binary>> = payload

        # Flag = 64 => Sent from the server

        <<protocol::binary-size(protocol_length), rest::binary>> = rest

        <<found, <<num_search_instance_ids::16-little>>, rest::binary>> = rest

        {search_instance_ids, _rest} = chunk_binary(rest, 32, num_search_instance_ids, [])

        {:ok,
         %{
           guid: guid,
           search_seq_id: search_seq_id,
           server_address: server_address,
           server_port: server_port,
           protocol: protocol,
           found: found,
           search_instance_ids: search_instance_ids
         }}

      _ ->
        {:error, "Binary data does not conform to expected search response format"}
    end
  end

  defp chunk_binary(data, _size_in_bits, number, acc) when number == 0 do
    {acc, data}
  end

  defp chunk_binary(data, size_in_bits, number, acc) do
    <<value::size(size_in_bits)-little, rest::binary>> = data
    chunk_binary(rest, size_in_bits, number - 1, [value | acc])
  end
end
