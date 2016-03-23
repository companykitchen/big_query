defmodule BigQuery.Types.DatasetReference do
  @moduledoc """
  Reference to a BigQuery dataset.

  Fields:
  * datasetId - [Required] The ID of the dataset containing this table.
  * projectId - [Required] The ID of the project containing this table.
  """
  defstruct [:datasetId, :projectId]

  @type t :: %__MODULE__{
    datasetId: String.t,
    projectId: String.t
  }
end