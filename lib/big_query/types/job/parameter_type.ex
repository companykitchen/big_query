defmodule BigQuery.Types.ParameterType do
  defstruct [:type, :arrayType, :structTypes]

  @type t :: %__MODULE__{
    type: String.t,
    arrayType: t,
    structTypes: [%{name: String.t, type: t, description: String.t}]
  }
end
