defmodule BigQuery.Types.ParameterType do
  defstruct [:type]

  @type t :: %__MODULE__{
    type: String.t
  }
end
