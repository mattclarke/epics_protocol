defmodule EpicsProtocol do
  def search_for_pv(name) do
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
    :ok = :gen_udp.send(socket, {172, 18, 23, 255}, 5076, data)

    :gen_udp.recv(socket, 0, _timeout = 5000)
  end

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

  def create_channel(socket, pvname, request_id) do
    # TODO: these numbers (1234) need to be unique
    request = Epics.Channel.create_channel_request(pvname, request_id)
    :ok = :gen_tcp.send(socket, request)
    {:ok, reply} = :gen_tcp.recv(socket, 0, 5000)
    Epics.Channel.decode_create_channel_response(reply, request_id)
  end

  def get_command_init(socket, server_channel_id, request_id) do
    # Do initial get to get the structure with values
    get_cmd = Epics.GetCommand.create_init_get_command(server_channel_id, request_id)
    :ok = :gen_tcp.send(socket, get_cmd)
    {:ok, reply} = :gen_tcp.recv(socket, 0, 5000)
    {:ok, _structure} = Epics.GetCommand.decode_channel_get_response_init(reply)
  end

  def get_command(socket, server_channel_id, request_id, fields) do
    # Make a proper get request to get the values
    get_cmd = Epics.GetCommand.create_get_command(server_channel_id, request_id)
    :ok = :gen_tcp.send(socket, get_cmd)
    {:ok, reply} = :gen_tcp.recv(socket, 0, 5000)
    {:ok, _response} = Epics.GetCommand.decode_channel_get_response(fields, reply)
  end

  def print_pv_data(fields, values) do
    value_paths = Epics.PvStructure.get_value_paths_in_order(fields)
      value_paths
        |> Enum.reduce(nil, fn path, acc ->
          value = Map.get(values, path)
          spath = Enum.join(path, ":")
          IO.puts("#{spath} #{inspect value}")
          acc
      end)
  end

  def pvget(pvname, address, port) do
    {:ok, socket} = establish_connection(address, port)
    {:ok, response} = create_channel(socket, pvname, 12345)
    {:ok, structure} = get_command_init(socket, response.server_channel_id, 12345)
    {:ok, response} = get_command(socket, response.server_channel_id,12345, structure.fields)
    print_pv_data(structure.fields, response.values)
  end
end
