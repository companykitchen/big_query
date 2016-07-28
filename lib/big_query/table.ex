defmodule BigQuery.Table do
  use BigQuery.Resource

  alias BigQuery.Types.{Column, Table, TableList}

  @spec get(String.t, String.t, String.t) :: {:ok, Table.t}| {:error, BigQuery.Resource.response | String.t}
  def get(project_id, dataset_id, table_id) do
    url = table_url(project_id, dataset_id, table_id)

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %Table{})
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error getting Table resource for table_id: #{table_id}:\n#{inspect reason}"}
    end
  end

  @doc """
  Insert a Table resource.

  The table resource requires, at minimum, the schema and tableReference fields
  to be non-nil.
  """
  @spec insert(String.t, String.t, Table.t) :: {:ok, Table.t} | {:error, BigQuery.Resource.response | String.t}
  def insert(project_id, dataset_id, %Table{schema: schema, tableReference: table_ref} = table) when schema != nil and table_ref != nil do
    url = tables_url(project_id, dataset_id)

    table_map = clean_up_map(table)

    case post(url, table_map) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          Poison.decode(resp[:body], as: %Table{})
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error inserting new BigQuery table: #{inspect reason}"}
    end
  end

  @spec list(String.t, String.t, opts :: [maxResults: integer  | nil, pageToken: String.t | nil]) :: {:ok, TableList.t} | {:error, BigQuery.Resource.response | String.t}
  def list(project_id, dataset_id, opts \\ [maxResults: nil, pageToken: nil]) do
    url = case build_query_string(opts) do
      "" -> tables_url(project_id, dataset_id)
      qs -> tables_url(project_id, dataset_id) <> "?" <> qs
    end

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          list_resp = Poison.decode!(resp[:body], as: %TableList{})

          {:ok, list_resp}
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error listing tables\n#{inspect reason}"}
    end
  end


  @doc """
      Delete a Table.

      Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
      """

  @spec delete(String.t, String.t, String.t) :: :ok | {:error, BigQuery.Resource.response | String.t}
  def delete(project_id, dataset_id, table_id) do
    url = table_url(project_id, dataset_id, table_id)

    case delete(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          :ok
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error getting Table resource for table_id: #{table_id}:\n#{inspect reason}"}
    end
  end


  defp tables_url(project_id, dataset_id) do
    base_url() <> "/projects/" <> project_id <> "/datasets/" <> dataset_id <> "/tables"
  end

  defp table_url(project_id, dataset_id, table_id) do
    tables_url(project_id, dataset_id) <> "/" <> table_id
  end
end