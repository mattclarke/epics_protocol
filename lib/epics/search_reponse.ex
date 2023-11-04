defmodule Epics.SearchReponse do
  alias Epics.SearchReponse

  defstruct [
    :found,
    :guid,
    :protocol,
    :search_instance_ids,
    :server_address,
    :server_port,
    :search_seq_id
  ]

  @spec decode({any(), any(), any()}) ::
          {:error, String.t()}
          | {:ok,
             %{
               found: byte(),
               guid: non_neg_integer(),
               protocol: String.t(),
               search_instance_ids: [non_neg_integer()],
               search_seq_id: non_neg_integer(),
               server_address: non_neg_integer(),
               server_port: non_neg_integer()
             }}
  def decode({_ip, _port, data} = _reply) do
    # TODO: write tests for this whole function

    case data do
      <<0xCA, _version, _flags, 4, <<_payload_size::32-little>>, payload::binary>> ->
        <<(<<guid::96-little>>), <<search_seq_id::32-little>>, <<server_address::128-little>>,
          <<server_port::16-little>>, <<protocol_length::8-little>>, rest::binary>> = payload

        # _flags = 64 => Sent from the server

        <<protocol::binary-size(protocol_length), rest::binary>> = rest

        <<found, <<num_search_instance_ids::16-little>>, rest::binary>> = rest

        {search_instance_ids, _rest} = chunk_binary(rest, 32, num_search_instance_ids, [])

        {:ok,
         %SearchReponse{
           found: found,
           guid: guid,
           protocol: protocol,
           search_instance_ids: search_instance_ids,
           server_address: server_address,
           server_port: server_port,
           search_seq_id: search_seq_id
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
