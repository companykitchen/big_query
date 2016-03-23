defmodule BigQuery.Types.Error do
  @moduledoc """
  BigQuery Error struct.

  Fields:
  * debugInfo - Debugging info, used internally by Google.
  * location - Specifies where the error occurred, if present.
  * message - A human-readable description of the error.
  * reason - A short error code that summarizes the error.
  """
  defstruct [:debugInfo, :location, :message, :reason]

  @type t :: %__MODULE__{
    debugInfo: String.t,
    location: String.t,
    message: String.t,
    reason: String.t
  }
end