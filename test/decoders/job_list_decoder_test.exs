defmodule BigQuery.JobList.DecoderTest do
  use ExUnit.Case
  doctest BigQuery.Types.JobList

  alias BigQuery.Types.Job
  alias BigQuery.Types.JobList

  test "joblist with no jobs listed" do
    job_list = %{"kind" => "bigquery#jobList", "etag" => "blar"}

    expected = %JobList{kind: "bigquery#jobList", etag: "blar", jobs: []}
    result = Poison.Decode.decode(job_list, as: %JobList{jobs: [%Job{}]})

    assert result == expected
  end

  test "joblist with jobs field set as nil" do
    job_list = %{"etag" => "blar", "jobs" => nil}
    expected = %JobList{etag: "blar", jobs: []}
    result = Poison.Decode.decode(job_list, as: %JobList{jobs: [%Job{}]})

    assert result == expected
  end

  test "joblist with a single job" do
    job_list = %{"etag" => "blar", "jobs" => [%{"etag" => "blar_job"}]}
    expected = %JobList{etag: "blar", jobs: [%Job{etag: "blar_job"}]}
    result = Poison.Decode.decode(job_list, as: %JobList{jobs: [%Job{}]})

    assert result == expected
  end

  test "joblist with multiple jobs" do
    job_list = %{"etag" => "blar", "jobs" => [%{"etag" => "blar_job_1"}, %{"etag" => "blar_job_2"}, %{"etag" => "blar_job_3"}]}
    expected = %JobList{etag: "blar", jobs: [%Job{etag: "blar_job_1"}, %Job{etag: "blar_job_2"}, %Job{etag: "blar_job_3"}]}
    result = Poison.Decode.decode(job_list, as: %JobList{jobs: [%Job{}]})

    assert result == expected
  end
end