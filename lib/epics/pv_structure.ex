defmodule Epics.PvStructure do
  alias Epics.PvStructure
  defstruct [:name, :type, :introspection_id, :fields, :value]

  def create(name, type, introspection_id \\ nil, fields \\ nil, value \\ nil) do
    %PvStructure{
      name: name,
      type: type,
      introspection_id: introspection_id,
      fields: fields,
      value: value
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
end
