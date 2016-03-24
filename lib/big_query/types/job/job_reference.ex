defmodule BigQuery.Types.JobReference do
  defstruct [:projectId, :jobId]

  @type t :: %__MODULE__{
    projectId: String.t,
    jobId: String.t
  }
end