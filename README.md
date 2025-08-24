# EpicsProtocol

## Run
```
$ iex -S mix

> pvname = "SIMPLE:VALUE2"
> request_id = 12345
> {:ok, reply} = EpicsProtocol.search_for_pv(pvname)
> {:ok, response} = Epics.SearchReponse.decode(reply)
> {:ok, socket} = EpicsProtocol.establish_connection(response.server_address, response.server_port)
> {:ok, channel} = EpicsProtocol.create_channel(socket, pvname, request_id)
> {:ok, structure} = EpicsProtocol.get_command_init(socket, channel.server_channel_id, request_id)
> {:ok, command} = EpicsProtocol.get_command(socket, channel.server_channel_id, request_id, structure.fields)

# Or just do this:
> EpicsProtocol.pvget("SIMPLE:VALUE2")
```

## Useful reminders

```# mix dialyzer```

```> IEx.Helpers.recompile()```

# How to break up an ipv6 address
<<a::16, b::16, c::16, d::16, e::16, f::16, g::16, h::16>> = <<79226953588444722964369244160::128-little>>

0000:0000:0000:0000:0000:ffff:0000:0000 = ten zeros then 255 255 0 0 0 0

# TODO
- support waveforms
- create a monitor
- handle changesets
- put status checking code in a module to reduce duplication
- handle bad status messages
- close the channel after finished
- search response is missing tests
- channel is missing tests
