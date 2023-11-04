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
    # Need timeouts
    :ok = :gen_udp.send(socket, {192, 168, 0, 255}, 5076, data)

    :gen_udp.recv(socket, 0)
  end
end
