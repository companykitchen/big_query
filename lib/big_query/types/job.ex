defmodule BigQuery.Types.Job do
  @derive [Poison.Decoder]
  alias BigQuery.Types.{JobConfiguration, JobReference, JobStatistics, JobStatus}

  defstruct kind: "bigquery#job", etag: nil, id: nil, selfLink: nil,
            jobReference: nil, configuration: nil, status: nil, statistics: nil,
            user_email: nil

  @type t :: %__MODULE__{
    kind: String.t,
    etag: String.t,
    id: String.t,
    selfLink: String.t,
    jobReference: JobReference.t,
    configuration: JobConfiguration.t,
    status: JobStatus.t,
    statistics: JobStatistics.t,
    user_email: String.t
  }
end

defmodule BigQuery.Types.JobList do
  #@derive [Poison.Decoder]

  alias BigQuery.Types.Job

  defstruct kind: "bigquery#jobList", etag: nil, nextPageToken: nil, jobs: nil

  @type t :: %__MODULE__{
    kind: String.t,
    etag: String.t,
    nextPageToken: String.t | nil,
    jobs: [Job.t]
  }
end

defimpl Poison.Decoder, for: BigQuery.Types.JobList do
  def decode(job_list, _opts) do
    empty_job = %BigQuery.Types.Job{}
    jobs = Enum.filter(job_list.jobs || [], &(&1 != empty_job))

    %{job_list | jobs: jobs}
  end
end

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
  """
  defstruct kind: "bigquery#queryRequest", query: nil, maxResults: nil,
            defaultDataset: nil, timeoutMs: nil, dryRun: nil, useQueryCache: nil

  @type t :: %__MODULE__{
    kind: String.t,
    query: String.t,
    maxResults: non_neg_integer,
    defaultDataset: BigQuery.Types.DatasetReference.t,
    timeoutMs: non_neg_integer,
    dryRun: boolean,
    useQueryCache: boolean
  }
end

defmodule BigQuery.Types.QueryResultRow do
  @derive [Poison.Decoder]

  defstruct [:f]

  @type t :: %__MODULE__{
    f: [BigQuery.Types.QueryResultCell.t]
  }
end

defmodule BigQuery.Types.QueryResultCell do
  @derive [Poison.Decoder]

  defstruct [:v]

  @type t :: %__MODULE__{
    v: boolean | float | integer | map() | String.t | BigQuery.Types.QueryResultRow | [BigQuery.Types.QueryResultCell]
  }
end

defmodule BigQuery.Types.QueryResultsResponse do
  alias BigQuery.Types.{Error, JobReference, Schema}

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
  alias BigQuery.Types.{Error, JobReference, QueryResultRow, Schema}

  def decode(result, _opts) do
    result
    |> filter_member_list(:errors, %Error{})
    |> filter_member_list(:rows, %QueryResultRow{})
    |> filter_member(:schema, %Schema{}, nil)
  end

  defp filter_member(result, key, compare_to, default) do
    if Map.get(result, key) == compare_to do
      Map.put(result, key, default)
    else
      result
    end
  end

  defp filter_member_list(result, key, compare_to) do
    list = Map.get(result, key)
    new_list = Enum.filter(list || [], &(&1 != compare_to))

    Map.put(result, key, new_list)
  end
end

defmodule BigQuery.Types.JobReference do
  defstruct [:projectId, :jobId]

  @type t :: %__MODULE__{
    projectId: String.t,
    jobId: String.t
  }
end

defmodule BigQuery.Types.JobStatus do
  alias BigQuery.Types.Error

  defstruct [:errors, :errorResult, :state]

  @type t :: %__MODULE__{
    errors: [Error.t],
    errorResult: Error.t,
    state: String.t
  }
end

defmodule BigQuery.Types.JobStatistics do
  defstruct [:creationTime, :startTime, :endTime, :totalBytesProcessed, :query,
              :load, :extract]

  @type t :: %__MODULE__{
    creationTime: integer,
    startTime: integer,
    endTime: integer,
    totalBytesProcessed: integer,
    query: query_statistics,
    load: load_statistics,
    extract: extract_statistics
  }

  @type extract_statistics :: %{
    destinationUriFileCounts: [integer]
  }

  @type load_statistics :: %{
    inputFiles: integer,
    inputFileBytes: integer,
    outputRows: integer,
    outputBytes: integer
  }

  @type query_statistics :: %{
    queryPlan: [query_statistic],
    totalBytesProcessed: integer,
    totalBytesBilled: integer,
    billingTier: integer,
    cacheHit: boolean
  }

  @type query_statistic :: %{
    name: String.t,
    id: integer,
    waitRowAvg: float,
    waitRatioMax: float,
    readRatioAvg: float,
    readRatioMax: float,
    computeRatioAvg: float,
    computeRatioMax: float,
    writeRatioAvg: float,
    writeRatioMax: float,
    recordsRead: integer,
    recordsWritten: integer,
    steps: [query_step]
  }

  @type query_step :: %{
    kind: String.t,
    substeps: [String.t]
  }
end