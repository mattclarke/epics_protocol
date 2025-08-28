defmodule Epics.Protocol do
  @spec create_search_message(non_neg_integer(), String.t()) :: [
          binary()
        ]
  def create_search_message(reply_port, pv_name) do
    pv_name_length = String.length(pv_name)
    payload_size = 38 + pv_name_length

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
      pv_name_length,
      # Channel name
      pv_name
    ]
  end
end
