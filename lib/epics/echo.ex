defmodule Epics.Echo do
  alias Epics.Echo
  defstruct [:flags, :payload]

  @spec decode(binary()) ::
          {:error, String.t()} | {:ok, %Epics.Echo{flags: byte(), payload: binary()}}
  def decode(data) do
    case data do
      <<0xCA, _version, flags, 2, <<_payload_size::32-little>>, payload::binary>> ->
        # Flag should be 65 => 64 = from server, 1 = control message
        {:ok, %Echo{flags: flags, payload: payload}}

      _ ->
        {:error, "Binary data does not conform to expected echo format"}
    end
  end
end
