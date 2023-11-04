defmodule Epics.Protocol do
  def create_search_message(reply_port, pv_name) do
    [
      0xCA,                          # Magic byte
      2,                             # Version
      0,                             # Flags
      3,                             # Command
      <<51::32-little>>,             # Payload size - how is this calculated?
      <<1::32-little>>,              # Search sequence ID
      0,                             # Flags
      0,                             # Reserved
      0,                             # Reserved
      0,                             # Reserved
      <<0::32-little>>,              # Reponse address (16 bytes)
      <<0::32-little>>,
      <<0::16-little>>,
      0xFF,
      0xFF,
      0,                             # IP address
      0,                             # IP address
      0,                             # IP address
      0,                             # IP address
      <<reply_port::16-little>>,     # Port
      1,                             # Num items in protocol array
      3,                             # Size of string array
      "tcp",                         # Protocol
      <<1::16-little>>,              # Num channels
      <<12345::32-little>>,          # Search instance ID
      13,                            # Size of channel name
      pv_name                        # Channel name
    ]
  end

  def decode_search_response(reply) do

  end
end
