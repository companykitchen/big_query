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


defmodule BigQuery.Types.ConfigurationLoad do
  alias BigQuery.Types.{TableReference}
  @moduledoc """
  Configuration for a Load job.
  See https://cloud.google.com/bigquery/docs/reference/v2/jobs#configuration.load
  for detailed field information.

  Fields:
  * allowJaggedRows - [Optional] Accept rows that are missing trailing optional columns.
  * allowQuotedNewlines - Indicates if BigQuery should allow quoted data sections that contain newline characters in a CSV file.
  * autodetect - [Experimental] Indicates if we should automatically infer the options and schema for CSV and JSON sources.
  * createDisposition - [Optional] Specifies whether the job is allowed to create new tables.
  * destinationTable - [Required] The destination table to load the data into.
  * encoding - [Optional] The character encoding of the data. The supported values are UTF-8 or ISO-8859-1.
  * fieldDelimiter - [Optional] The separator for fields in a CSV file.
  * ignoreUnknownValues - [Optional] Indicates if BigQuery should allow extra values that are not represented in the table schema.
  * maxBadRecords - [Optional] The maximum number of bad records that BigQuery can ignore when running the job.
  * projectionFields - 	[Experimental] indicates which entity properties to load into BigQuery from a Cloud Datastore backup.
  * quote - [Optional] The value that is used to quote data sections in a CSV file.
  * schema - [Optional] The schema for the destination table.
  * schemaInline - [Deprecated] The inline schema.
  * schemaInlineFormat - [Deprecated] The format of the schemaInline property.
  * skipLeadingRows - [Optional] The number of rows at the top of a CSV file that BigQuery will skip when loading the data.
  * sourceFormat - [Optional] The format of the data files.
  * sourceUris - [Required] The fully-qualified URIs that point to your data in Google Cloud Storage.
  * writeDisposition - [Optional] Specifies the action that occurs if the destination table already exists.

  """
  defstruct [
    :allowJaggedRows, :allowQuotedNewlines, :autodetect,
    :createDisposition, :destinationTable, :encoding, :fieldDelimiter, :ignoreUnknownValues,
    :maxBadRecords, :projectionFields, :quote, :schema, :schemaInline, :schemaInlineFormat,
    :skipLeadingRows, :sourceFormat, :sourceUris, :writeDisposition]

  @type t :: %__MODULE__{
    allowJaggedRows: boolean,
    allowQuotedNewlines: boolean,
    autodetect: boolean,
    createDisposition: String.t,
    destinationTable: TableReference.t,
    encoding: String.t,
    fieldDelimiter: String.t,
    ignoreUnknownValues: boolean,
    maxBadRecords: integer,
    projectionFields: [],
    quote: String.t,
    schema: map(),
    schemaInline: String.t,
    schemaInlineFormat: String.t,
    skipLeadingRows: integer,
    sourceFormat: String.t,
    sourceUris: [],
    writeDisposition: String.t
  }
end
