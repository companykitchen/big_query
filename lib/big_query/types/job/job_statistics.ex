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
