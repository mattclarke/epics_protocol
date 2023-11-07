defmodule Epics.GetCommand do
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
      0x08,
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
end
