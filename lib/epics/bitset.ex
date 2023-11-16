defmodule Epics.Bitset do
  def to_array(bitset) when byte_size(bitset) == 1 do
    convert(bitset, 0)
  end

  def to_array(bitset) do
    :binary.bin_to_list(bitset)
    |> Stream.with_index()
    |> Enum.reduce([], fn {value, i}, acc ->
      result = convert(<<value>>, 8 * i)
      acc ++ result
    end)
  end

  defp convert(bitset, offset) do
    as_list = for <<chunk::size(1) <- bitset>>, do: <<chunk::size(1)>>
    as_list = Enum.reverse(as_list)

    {result, _} =
      as_list
      |> Enum.reduce({[], offset}, fn value, {acc, i} ->
        case value do
          <<1::size(1)>> -> {[i | acc], i + 1}
          _ -> {acc, i + 1}
        end
      end)

    Enum.reverse(result)
  end
end
