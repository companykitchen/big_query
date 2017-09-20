defmodule BigQuery.Types.ParameterValue do
  defstruct [:value]

  @type t :: %__MODULE__{
    value: any
  }
end
