defmodule BigQuery.Types.Query do
  @moduledoc """
  A BigQuery Query Resource.
  See https://cloud.google.com/bigquery/docs/reference/v2/jobs/query for
  detailed information about the fields.

  Fields:
  * kind - bigquery#queryRequest
  * query - [Required] A BigQuery query string.
  * maxResults - [Optional] The maximum number of rows of data to return per page of results.
  * defaultDataset - [Optional] Specifies the default datasetId and projectId to assume for any unqualified table names in the query.
  * timeoutMs - [Optional] How long to wait for the query to complete, in milliseconds. The query will continue running if timeoutMs is exceeded, but the initial query request will return.
  * dryRun - [Optional] Don't actually execute the query.
  * useQueryCache - [Optional] Whether to look for the result in the query cache.
  * maximumBillingTier - [Optional] Overrides the bigquery default value for the billing tier limit
  """
  defstruct kind: "bigquery#queryRequest", query: nil, maxResults: nil,
            defaultDataset: nil, timeoutMs: nil, dryRun: nil, useQueryCache: nil, maximumBillingTier: nil, useLegacySql: nil, parameterMode: nil, queryParameters: []

  @type t :: %__MODULE__{
    kind: String.t,
    query: String.t,
    maxResults: non_neg_integer | nil,
    defaultDataset: BigQuery.Types.DatasetReference.t | nil,
    timeoutMs: non_neg_integer | nil,
    dryRun: boolean | nil,
    useQueryCache: boolean | nil,
    maximumBillingTier: String.t | nil ,
    useLegacySql: boolean | nil,
    parameterMode: String.t | nil,
    queryParameters: [BigQuery.Types.Parameter.t]
  }

end

defmodule BigQuery.Types.QueryResultCell do
  @derive [Poison.Decoder]

  defstruct [:v]

  @type t :: %__MODULE__{
    v: boolean | float | integer | map() | String.t | BigQuery.Types.QueryResultRow | [BigQuery.Types.QueryResultCell]
  }
end

defmodule BigQuery.Types.QueryResultRow do
  defstruct [:f]

  @type t :: %__MODULE__{
    f: [BigQuery.Types.QueryResultCell.t]
  }
end

defimpl Poison.Decoder, for: BigQuery.Types.QueryResultRow do
  import DecoderHelpers
  alias BigQuery.Types.QueryResultCell

  def decode(row, _options) do
    decode_member_list(row, :f, %QueryResultCell{})
  end
end

defmodule BigQuery.Types.QueryResultsResponse do
  alias BigQuery.Types.{Error, JobReference, QueryResultRow, Schema}

  defstruct kind: "bigquery#getQueryResultsResponse", etag: nil, schema: nil,
            jobReference: nil, totalRows: nil, pageToken: nil, rows: nil,
            totalBytesProcessed: nil, jobComplete: nil, errors: nil,
            cacheHit: nil

  @type t :: %__MODULE__{
    kind: String.t,
    etag: String.t,
    schema: Schema.t,
    jobReference: JobReference.t,
    totalRows: integer,
    rows: [QueryResultRow.t],
    jobComplete: boolean,
    pageToken: String.t,
    cacheHit: boolean,
    totalBytesProcessed: integer,
    errors: [Error.t]
  }
end

defimpl Poison.Decoder, for: BigQuery.Types.QueryResultsResponse do
  import DecoderHelpers
  alias BigQuery.Types.{Error, JobReference, QueryResultRow, Schema}

  def decode(result, _opts) do
    result
    |> decode_member_list(:rows, %QueryResultRow{})
    |> decode_member_list(:errors, %Error{})
    |> decode_member(:jobReference, %JobReference{})
    |> decode_member(:schema, %Schema{})
  end
end
