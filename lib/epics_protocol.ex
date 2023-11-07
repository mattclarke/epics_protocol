defmodule EpicsProtocol do
  def search_for_pv(name \\ "SIMPLE:VALUE2") do
    options = [
      {:mode, :binary},
      {:active, false},
      {:reuseaddr, true},
      {:broadcast, true}
    ]

    {:ok, socket} = :gen_udp.open(0, options)
    {:ok, port} = :inet.port(socket)

    data = Epics.Protocol.create_search_message(port, name)

    # Need to auto configure ip address somehow
    :ok = :gen_udp.send(socket, {192, 168, 0, 255}, 5076, data)

    :gen_udp.recv(socket, 0, _timeout = 5000)
  end

  @spec establish_connection(
          String.t(),
          non_neg_integer()
        ) ::
          {:ok,
           %Epics.ConnectionValidation{
             auth_modes: any(),
             buffer_size: non_neg_integer(),
             flags: byte(),
             introspection_size: char()
           }}
  def establish_connection(address, port) do
    options = [
      mode: :binary,
      active: false,
      reuseaddr: true,
      exit_on_close: false
    ]

    {:ok, socket} = :gen_tcp.connect(to_charlist(address), port, options)
    {:ok, reply} = :gen_tcp.recv(socket, 0, 5000)

    # Validation message is in fact two messages in one, an echo wrapping a validation
    {:ok, %Epics.Echo{payload: validation}} = Epics.Echo.decode(reply)
    {:ok, _request} = Epics.ConnectionValidation.decode_request(validation)
    :ok = :gen_tcp.send(socket, Epics.ConnectionValidation.encode_response())
    {:ok, reply} = :gen_tcp.recv(socket, 0, 5000)

    # Reply should be a connection validated message (9) contents are irrelevant?
    {:ok, _} = Epics.ConnectionValidation.is_validated(reply)
    {:ok, socket}
  end

  def create_channel(socket, pvname) do
    # TODO: these numbers (1234) need to be unique
    request = Epics.Channel.create_channel_request(pvname, 1234)
    :ok = :gen_tcp.send(socket, request)

    {:ok, reply} = :gen_tcp.recv(socket, 0, 5000)
    {:ok, response} = Epics.Channel.decode_create_channel_response(reply, 1234)
    get_cmd = Epics.GetCommand.create_init_get_command(response.server_channel_id, 12345)
    :ok = :gen_tcp.send(socket, get_cmd)
    {:ok, reply} = :gen_tcp.recv(socket, 0, 5000)

    # Reply is channelGetResponseInit
  end

  def pvget(pvname, address, port) do
    {:ok, socket} = establish_connection(address, port)
    create_channel(socket, pvname)
  end
end
