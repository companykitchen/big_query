defmodule BigQuery.Types.JobConfiguration do
  defstruct [:copy, :dryRun, :extract, :load, :query]

  @type t :: %__MODULE__{
    copy: map(),
    dryRun: boolean,
    extract: map(),
    load: map(),
    query: map
  }
end

defmodule BigQuery.Types.ConfigurationQuery do
  alias BigQuery.Types.{DatasetReference, TableReference}
  @moduledoc """
  Configuration for a Query job.
  See https://cloud.google.com/bigquery/docs/reference/v2/jobs#configuration.query
  for detailed field information.

  Fields:
  * allowLargeResults - allows the query to produce arbitrarily large result tables.
  * createDisposition - [Optional] Specifies whether the job is allowed to create new tables.
  * defaultDataset - [Optional] Specifies the default dataset to use for unqualified table names in the query.
  * destinationTable - Describes the table where the query results should be stored. If not present, a new table will be created to store the results.
  * flattenResults - [Optional] Flattens all nested and repeated fields in the query results.
  * maximumBillingTier - [Optional] Limits the billing tier for this job.
  * priority - [Optional] Specifies a priority for the query.
  * query - [Required] BigQuery SQL query to execute.
  * tableDefinitions - [Optional] If querying an external data source outside of BigQuery, describes it.
  * useLegacySql - [Experimental] Specifies whether to use BigQuery's legacy SQL dialect for this query.
  * useQueryCache - [Optional] Whether to look for the result in the query cache. 
  * userDefinedFunctionResources - [Experimental] Describes user-defined function resources used in the query.
  * writeDisposition - [Optional] Specifies the action that occurs if the destination table already exists.
  """
  defstruct [
    :allowLargeResults, :createDisposition, :defaultDataset,
    :destinationTable, :flattenResults, :maximumBillingTier, :priority, :query,
    :tableDefinitions, :useLegacySql, :useQueryCache,
    :userDefinedFunctionResources, :writeDisposition]

  @type t :: %__MODULE__{
    allowLargeResults: boolean,
    createDisposition: String.t,
    defaultDataset: DatasetReference.t,
    destinationTable: TableReference.t,
    flattenResults: boolean,
    maximumBillingTier: integer,
    priority: String.t,
    query: String.t,
    tableDefinitions: map(),
    useLegacySql: boolean,
    useQueryCache: boolean,
    userDefinedFunctionResources: [map()],
    writeDisposition: String.t
  }
end