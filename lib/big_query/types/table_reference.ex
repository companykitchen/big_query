defmodule BigQuery.Types.TableReference do
  @moduledoc """
  Reference to a BigQuery Table.

  Fields:
  * datasetId - [Required] The ID of the dataset containing this table.
  * projectId - [Required] The ID of the project containing this table.
  * tableId - [Required] The ID of the table. 
  """
  defstruct [:projectId, :datasetId, :tableId]

  @type t :: %__MODULE__{
    datasetId: String.t,
    projectId: String.t,
    tableId: String.t
  }
end