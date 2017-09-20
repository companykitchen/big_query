defmodule BigQuery.Types.Parameter do
  alias BigQuery.Types.{ParameterType, ParameterValue}
  defstruct [:parameterType, :parameterValue, :name]

  @type t :: %__MODULE__{
    parameterType: ParameterType.t,
    parameterValue: ParameterValue.t,
    name: String.t
  }
end
