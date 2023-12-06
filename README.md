# EpicsProtocol

## Run
```
$ iex -S mix

> {:ok, reply} = EpicsProtocol.search_for_pv()
> {:ok, response} = Epics.SearchReponse.decode(reply)
# IP and port are hard-coded - need to work out how to set them based on the response
> EpicsProtocol.pvget("SIMPLE:VALUE2", "192.168.0.174", 5075)
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
