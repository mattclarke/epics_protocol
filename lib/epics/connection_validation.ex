defmodule Epics.ConnectionValidation do
  alias Epics.ConnectionValidation
  defstruct [:flags, :buffer_size, :introspection_size, :auth_modes]

  @spec decode_request(binary()) ::
          {:ok,
           %ConnectionValidation{
             auth_modes: list(String.t()),
             buffer_size: non_neg_integer(),
             flags: byte(),
             introspection_size: char()
           }}
  def decode_request(data) do
    case data do
      <<0xCA, _version, flags, 1, <<_payload_size::32-little>>, <<buffer_size::32-little>>,
        <<introspection_size::16-little>>, num_auth, payload::binary>> ->
        # Flag should be 64 = from server
        # It is easier to extract the modes via a list
        payload = :binary.bin_to_list(payload)

        {modes, _rest} =
          Enum.reduce(0..(num_auth - 1), {[], payload}, fn _i, {modes, payload} ->
            [num_chars | payload] = payload
            {mode, payload} = Enum.split(payload, num_chars)

            {[List.to_string(mode) | modes], payload}
          end)

        {:ok,
         %ConnectionValidation{
           flags: flags,
           buffer_size: buffer_size,
           introspection_size: introspection_size,
           auth_modes: modes
         }}

      _ ->
        {:error, "Binary data does not conform to expected connection validation format"}
    end
  end

  def encode_response(
        buffer_size \\ 742_261_248,
        introspection_size \\ 65407,
        quality_of_service \\ 0,
        auth_mode \\ "ca"
      ) do
    # Only auth_mode for ca possible currently
    # clientReceiveBufferSize = 742261248 copied from pvget (4 bytes)
    # clientIntrospectionRegistryMaxSize = 65407 copied from pvget (2 bytes)
    # connectionQos = 0 (2 bytes)

    user = System.get_env("USER")
    {:ok, hostname} = :inet.gethostname()
    hostname = to_string(hostname)

    # Don't fully understand how the encoding works at the moment
    # fd id      complex structure
    # FD 01 00   80      00

    # clientReceiveBufferSize, clientIntrospectionRegistryMaxSize, connectionQos
    payload_size = 4 + 2 + 2
    # auth_mode
    payload_size = payload_size + (1 + String.length("ca"))
    # Structure description
    payload_size = payload_size + (1 + 2 + 2)
    # Field names
    payload_size =
      payload_size + (1 + 1 + String.length("user") + 1 + 1 + String.length("host") + 1)

    payload_size = payload_size + (1 + String.length(user) + 1 + String.length(hostname))

    [
      # HEADER
      # Magic byte
      0xCA,
      # Version
      2,
      # Flags
      0,
      # Command
      1,
      # Payload size in bytes (non-aligned)
      <<payload_size::32-little>>,
      # PAYLOAD
      # clientReceiveBufferSize
      <<buffer_size::32-little>>,
      # clientIntrospectionRegistryMaxSize
      <<introspection_size::16-little>>,
      # connectionQos
      <<quality_of_service::16-little>>,
      # size of authNZ
      String.length(auth_mode),
      # authNZ mode string
      auth_mode,
      # FieldDesc
      0xFD,
      0x01,
      0x00,
      0x80,
      0x00,
      # Num fields,
      2,
      # Size of string
      String.length("user"),
      # String
      "user",
      # Backtick is some sort of terminator?
      0x60,
      # Size of string
      String.length("host"),
      # String
      "host",
      # Backtick is some sort of terminator?
      0x60,
      # Length of string
      String.length(user),
      # String
      user,
      # Length of string
      String.length(hostname),
      # String
      hostname
    ]
  end

  def is_validated(data) do
    case data do
      <<0xCA, _version, _flags, 9, <<_payload_size::32-little>>, _payload::binary>> ->
        # TODO: check the status field is 255
        {:ok, ""}

      _ ->
        {:error, "Failed to validate connection"}
    end
  end
end
