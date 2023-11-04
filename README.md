# EpicsProtocol

## Run
```
$ iex -S mix

> {:ok, reply} = EpicsProtocol.search_for_pv()
> {:ok, response} = Epics.SearchReponse.decode(reply)
```

## Useful reminders

```# mix dialyzer```

```> IEx.Helpers.recompile()```

# How to break up an ipv6 address
<<a::16, b::16, c::16, d::16, e::16, f::16, g::16, h::16>> = <<79226953588444722964369244160::128-little>>