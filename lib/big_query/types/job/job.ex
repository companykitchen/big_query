defmodule BigQuery.Types.Job do
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

defimpl Poison.Decoder, for: BigQuery.Types.Job do
  import DecoderHelpers
  alias BigQuery.Types.{JobConfiguration, JobReference, JobStatistics,
        JobStatus}

  def decode(job, _options) do
    job
    |> decode_member(:configuration, %JobConfiguration{})
    |> decode_member(:jobReference, %JobReference{})
    |> decode_member(:statistics, %JobStatistics{})
    |> decode_member(:status, %JobStatus{})
  end
end
