# EpicsProtocol

## Run
```
$ iex -S mix

> {:ok, reply} = EpicsProtocol.search_for_pv()
> {:ok, response} = Epics.Protocol.decode_search_response(reply)
```

## Useful reminders

```# mix dialyzer```

```> IEx.Helpers.recompile()```