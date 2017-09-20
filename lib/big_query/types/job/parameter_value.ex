defmodule BigQuery.Types.ParameterValue do
  defstruct [:value, :arrayValues, :structValues]

  @type t :: %__MODULE__{
    value: any | nil,
    arrayValues: [t],
    structValues: %{(String.t | term) => t}
  }
end
