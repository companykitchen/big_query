defmodule BigQuery.Job do
  require Logger
  use BigQuery.Resource

  alias BigQuery.Types.{Job, JobList, QueryResultsResponse}

  @spec cancel(String.t, String.t) :: {:ok, Job.t} | {:error, any}
  def cancel(project_id, job_id) do
    url = job_base_url(project_id, job_id) <> "/cancel"

    case post(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          job_resp = Poison.decode!(resp[:body], as: %{job: %Job{}})
          {:ok, job_resp.job}
        else
          {:error, "BigQuery returned a status of #{resp[:status_code]} when attempting to cancel job #{job_id}. Response body: #{inspect resp[:body]}"}
        end
      {:error, reason} ->
        {:error, "Error canceling job: #{job_id}\n#{inspect reason}"}
    end
  end

  @spec get(String.t, String.t) :: {:ok, Job.t} | {:error, any}
  def get(project_id, job_id) do
    url = job_base_url(project_id, job_id)

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %Job{})
        else
          {:error, "BigQuery returned a status of #{resp[:status_code]} for job_id: #{job_id}. Response body: #{inspect resp[:body]}"}
        end
      {:error, reason} ->
        {:error, "Error getting Job resource for job_id: #{job_id}:\n#{inspect reason}"}
    end
  end

  @spec get_query_results(String.t, String.t, opts :: [maxResults: non_neg_integer | nil, pageToken: String.t | nil, startIndex: non_neg_integer | nil, timeoutMs: non_neg_integer | nil]) :: {:ok, QueryResultsResponse.t} | {:error, any}
  def get_query_results(project_id, job_id, opts \\ [maxResults: nil, pageToken: nil, startIndex: nil, timeoutMs: nil]) do
    url = case build_query_string(opts) do
      "" -> query_url(project_id, job_id)
      qs -> query_url(project_id, job_id) <> "?" <> qs
    end

    Logger.debug "Querying #{url}..."

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          query_resp = Poison.decode!(resp[:body], as: %QueryResultsResponse{})

          result = if query_resp.jobComplete == false do
            # The query hasn't finished running. Sleep for a bit an try again.
            :timer.sleep(500)
            get_query_results(project_id, job_id, opts)
          else
            if query_resp.pageToken != nil do
              # TODO: This isn't tail recursive...
              new_opts = Keyword.put(opts, :pageToken, query_resp.pageToken)
              more_rows = get_query_results(project_id, job_id, new_opts)

              %{query_resp | rows: query_resp.rows ++ more_rows}
            else
              query_resp
            end
          end

          {:ok, result}
        else
          {:error, "BigQuery returned status #{resp[:status_code]}. Response details: #{inspect resp}"}
        end
      {:error, reason} ->
        {:error, "Error checking query results\n#{inspect reason}"}
    end
  end

  @spec insert(String.t, Job.t) :: {:ok, Job.t} | {:error, any}
  def insert(project_id, job) do
    url = jobs_url(project_id)

    case post(url, job) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %Job{})
        else
          {:error, "BigQuery returned a status of #{resp[:status_code]}. Response body: #{inspect resp[:body]}"}
        end
      {:error, reason} ->
        {:error, "Error inserting new BigQuery job: #{inspect reason}"}
    end
  end

  @spec list(String.t, opts :: [allUsers: boolean, maxResults: non_neg_integer | nil, projection: String.t | nil, stateFilter: String.t | nil]) :: {:ok, [BigQuery.Types.Job.t]} | {:error, any}
  def list(project_id, opts \\ [allUsers: nil, maxResults: nil, projection: nil, stateFilter: nil]) do
    case list_jobs(project_id, nil, opts) do
      job_list when is_list(job_list) -> {:ok, job_list}
      error -> error
    end
  end

  @spec query(String.t, Query.t) :: {:ok, QueryResultsResponse.t} | {:error, any}
  def query(project_id, query) do
    url = queries_url(project_id)

    case post(url, query) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %QueryResultsResponse{})
        else
          {:error, "BigQuery returned a status of #{resp[:status_code]}. Response body: #{inspect resp[:body]}"}
        end
      {:error, reason} ->
        {:error, "Error performing query:\n#{inspect reason}"}
    end
  end

  @spec list_jobs(String.t, String.t | nil, Keyword.t) :: [BigQuery.Types.Job.t] | {:error, any}
  defp list_jobs(project_id, page_token, opts) do
    new_opts = Keyword.put(opts, :pageToken, page_token)

    url = case build_query_string(new_opts) do
      "" -> jobs_url(project_id)
      qs -> jobs_url(project_id) <> "?" <> qs
    end

    Logger.debug "Querying #{url}..."

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          list_resp = Poison.decode!(resp[:body], as: %JobList{})

          if list_resp.nextPageToken != nil do
            Logger.debug "Retrieved #{length list_resp.jobs} jobs. Loading more..."
            # TODO: This isn't tail-recursive...
            jobs = list_jobs(project_id, list_resp.nextPageToken, opts)
            list_resp.jobs ++ jobs
          else
            list_resp.jobs
          end
        else
          {:error, "BigQuery returned status #{resp[:status_code]}. Response details: #{inspect resp}"}
        end
      {:error, reason} ->
        {:error, "Error listing jobs\n#{inspect reason}"}
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