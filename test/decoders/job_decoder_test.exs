defmodule BigQuery.Types.Job.DecoderTest do
  use ExUnit.Case
  doctest BigQuery.Types.Job

  alias BigQuery.Types.{Job, JobConfiguration, JobReference, JobStatistics,
        JobStatus}

  test "Job with no sub-records" do
    job = %{"etag" => "blar"}
    expected = %Job{etag: "blar"}
    result = Poison.Decode.decode(job, as: %Job{})

    assert result == expected
  end

  test "job with a configuration" do
    job = %{"etag" => "blar", "configuration" => %{"dryRun" => false}}
    expected = %Job{etag: "blar", configuration: %JobConfiguration{dryRun: false}}
    result = Poison.Decode.decode(job, as: %Job{})

    assert result == expected
  end

  test "job with a reference" do
    job = %{"etag" => "blar", "jobReference" => %{"projectId" => "1", "jobId" => "z"}}
    expected = %Job{etag: "blar", jobReference: %JobReference{projectId: "1", jobId: "z"}}
    result = Poison.Decode.decode(job, as: %Job{})

    assert result == expected
  end

  test "job with statistics" do
    job = %{"etag" => "blar", "statistics" => %{"creationTime" => 1337}}
    expected = %Job{etag: "blar", statistics: %JobStatistics{creationTime: 1337}}
    result = Poison.Decode.decode(job, as: %Job{})

    assert result == expected
  end

  test "job with status" do
    job = %{"etag" => "blar", "status" => %{"state" => "cool"}}
    expected = %Job{etag: "blar", status: %JobStatus{state: "cool", errors: []}}
    result = Poison.Decode.decode(job, as: %Job{})

    assert result == expected
  end
end