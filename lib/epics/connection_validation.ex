defmodule Epics.ConnectionValidation do
  alias Epics.ConnectionValidation
  defstruct [:flags, :buffer_size, :introspection_size, :auth_modes]

  @spec decode(binary()) ::
          {:ok,
           %Epics.ConnectionValidation{
             auth_modes: list(String.t()),
             buffer_size: non_neg_integer(),
             flags: byte(),
             introspection_size: char()
           }}
  def decode(data) do
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
    end
  end
end
