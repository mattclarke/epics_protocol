defmodule Epics.PvStructure do
  alias Epics.PvStructure
  defstruct [:name, :type, :introspection_id, :fields]

  def create(name, type, introspection_id \\ nil, fields \\ nil) do
    %PvStructure{name: name, type: type, introspection_id: introspection_id, fields: fields}
  end
end
