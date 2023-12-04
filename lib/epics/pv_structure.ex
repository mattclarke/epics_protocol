defmodule Epics.PvStructure do
  alias Epics.PvStructure
  defstruct [:name, :type, :introspection_id, :fields, :value]

  def create(name, type, introspection_id \\ nil, fields \\ nil) do
    %PvStructure{
      name: name,
      type: type,
      introspection_id: introspection_id,
      fields: fields,
    }
  end

  def get_field(structure, name) do
    structure.fields
    |> Enum.reduce_while(nil, fn x, acc ->
      if x.name == name do
        {:halt, x}
      else
        {:cont, acc}
      end
    end)
  end

  def get_field_from_path(structure, path) do
   {field, _} = find_field_and_parent_from_path(structure, path)
   field
  end

  defp find_field_and_parent_from_path(structure, [name]) do
    field = get_field(structure, name)
    if field == nil do
      {nil, nil}
    else
      {field, structure}
    end
  end

  defp find_field_and_parent_from_path(structure, [name | path]) do
    field = get_field(structure, name)
    if field == nil do
      {nil, nil}
    else
      find_field_and_parent_from_path(field, path)
    end
  end

  def get_value_paths_in_order(structure) do
    flatten(structure, [], [])
  end

  defp flatten(structure, path, acc) do
    if structure.fields != nil do
      Enum.reduce(structure.fields, acc, fn field, acc ->
        flatten(field, path ++ [structure.name], acc)
      end)
    else
      [_ | tail] = path ++ [structure.name]
      acc ++ [tail]
    end
  end
end
