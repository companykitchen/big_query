defmodule BigQuery.Types.JobList do
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
  import DecoderHelpers
  def decode(job_list, _opts) do
    decode_member_list(job_list, :jobs, %BigQuery.Types.Job{})
  end
end