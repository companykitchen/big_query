defmodule BigQuery.Job do
  require Logger
  use BigQuery.Resource

  alias BigQuery.Types.{Job, JobList, Query, QueryResultsResponse}

  @spec cancel(String.t, String.t) :: {:ok, Job.t} | {:error, BigQuery.Resource.response | String.t}
  def cancel(project_id, job_id) do
    url = job_base_url(project_id, job_id) <> "/cancel"

    case post(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          job_resp = Poison.decode!(resp[:body], as: %{job: %Job{}})
          {:ok, job_resp.job}
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error canceling job: #{job_id}\n#{inspect reason}"}
    end
  end

  @spec get(String.t, String.t) :: {:ok, Job.t} | {:error, BigQuery.Resource.response | String.t}
  def get(project_id, job_id) do
    url = job_base_url(project_id, job_id)

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %Job{})
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error getting Job resource for job_id: #{job_id}:\n#{inspect reason}"}
    end
  end

  @spec get_query_results(String.t, String.t, opts :: [maxResults: non_neg_integer | nil, pageToken: String.t | nil, startIndex: non_neg_integer | nil, timeoutMs: non_neg_integer | nil]) :: {:ok, QueryResultsResponse.t} | {:error, BigQuery.Resource.response | String.t}
  def get_query_results(project_id, job_id, opts \\ [maxResults: nil, pageToken: nil, startIndex: nil, timeoutMs: nil]) do
    url = case build_query_string(opts) do
      "" -> query_url(project_id, job_id)
      qs -> query_url(project_id, job_id) <> "?" <> qs
    end

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          query_resp = Poison.decode!(resp[:body], as: %QueryResultsResponse{})

          {:ok, query_resp}
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error checking query results\n#{inspect reason}"}
    end
  end

  @spec insert(String.t, Job.t) :: {:ok, Job.t} | {:error, BigQuery.Resource.response | String.t}
  def insert(project_id, %Job{} = job) do
    url = jobs_url(project_id)

    case post(url, job) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %Job{})
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error inserting new BigQuery job: #{inspect reason}"}
    end
  end

  @spec list(String.t, opts :: [allUsers: boolean, maxResults: non_neg_integer | nil, projection: String.t | nil, stateFilter: String.t | nil]) :: {:ok, JobList.t} | {:error, BigQuery.Resource.response | String.t}
  def list(project_id, opts \\ [allUsers: nil, maxResults: nil, projection: nil, stateFilter: nil]) do
    url = case build_query_string(opts) do
      "" -> jobs_url(project_id)
      qs -> jobs_url(project_id) <> "?" <> qs
    end

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          list_resp = Poison.decode!(resp[:body], as: %JobList{})
          {:ok, list_resp}
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error listing jobs\n#{inspect reason}"}
    end
  end

  @spec query(String.t, Query.t) :: {:ok, QueryResultsResponse.t} | {:error, BigQuery.Resource.response | String.t}
  def query(project_id, %Query{} = query) do
    url = queries_url(project_id)

    case post(url, query) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %QueryResultsResponse{})
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error performing query:\n#{inspect reason}"}
    end
  end

  defp job_base_url(project_id, job_id) do
    jobs_url(project_id) <> "/" <> job_id
  end

  defp jobs_url(project_id) do
    base_url() <> "/projects/" <> project_id <> "/jobs"
  end

  defp queries_url(project_id) do
    base_url() <> "/projects/" <> project_id <> "/queries"
  end

  defp query_url(project_id, job_id) do
    queries_url(project_id) <> "/" <> job_id
  end
end