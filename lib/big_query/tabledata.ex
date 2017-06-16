defmodule BigQuery.Tabledata do
  require Logger
  use BigQuery.Resource

  alias BigQuery.Types.Error

  @type insert_row :: {unique_row_id :: String.t, row :: map()}
  @type insert_error :: %{index: non_neg_integer, errors: [Error.t]}
  @type insert_all_response :: %{kind: String.t, insertErrors: [insert_error]}

  @doc """
  Stream data into BigQuery using the Streaming API. Read the BigQuery API documentation [here](https://cloud.google.com/bigquery/docs/reference/v2/tabledata/insertAll) for more information.

  It's important that the 4th parameter is a list of tuples where the first element is a unique identifier for the row contained in the second element. This unique identifier is used by BigQuery to prevent duplication.
  """
  @spec insert_all(String.t, String.t, String.t, [insert_row], [skipInvalidRows: boolean, ignoreUnknownValues: boolean]) :: {:ok, insert_all_response} | {:error, BigQuery.Resource.response | String.t}
  def insert_all(project_id, dataset_id, table_id, rows, opts \\ [skipInvalidRows: false, ignoreUnknownValues: false]) do
    url = insert_url(project_id, dataset_id, table_id)

    prepared_rows = Enum.into(rows, [], fn ({unique_row_id, row}) ->
      %{
        insertId: unique_row_id,
        json: row
      }
    end)

    body = %{
      kind: "bigquery#tableDataInsertAllRequest",
      ignoreUnknownValues: opts[:ignoreUnknownValues],
      skipInvalidRows: opts[:skipInvalidRows],
      rows: prepared_rows
    }

    case post(url, body) do
      {:ok, %{status_code: status} = resp} when status in 200..299 ->
        insert_all_response = Poison.decode!(resp[:body])
        {:ok, insert_all_response}
      {:ok, resp} -> {:error, resp}
      {:error, reason} ->
        {:error, "Error streaming rows: #{inspect reason}"}
    end
  end

  @spec insert_url(String.t, String.t, String.t) :: String.t
  defp insert_url(project_id, dataset_id, table_name) do
    "#{base_url()}/projects/#{project_id}/datasets/#{dataset_id}/tables/#{table_name}/insertAll"
  end
end