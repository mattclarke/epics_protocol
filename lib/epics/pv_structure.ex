defmodule Epics.PvStructure do
  alias Epics.PvStructure
  defstruct [:name, :type, :introspection_id, :fields, :value]

  def create(name, type, introspection_id \\ nil, fields \\ nil, value \\ nil) do
    %PvStructure{name: name, type: type, introspection_id: introspection_id, fields: fields, value: value}
  end
end
