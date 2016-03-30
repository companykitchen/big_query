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

  @spec list(String.t, String.t, opts :: [maxResults: integer  | nil, pageToken: String.t | nil]) :: {:ok, [Table.t]} | {:error, BigQuery.Resource.response | String.t}
  def list(project_id, dataset_id, opts \\ [maxResults: nil, pageToken: nil]) do
    case do_list_tables(project_id, dataset_id, opts) do
      {:error, reason} -> {:error, reason}
      tables -> {:ok, tables}
    end
  end

  @spec do_list_tables(String.t, String.t, Keyword.t) :: [Table.t] | {:error, BigQuery.Resource.response | String.t}
  defp do_list_tables(project_id, dataset_id, opts) do
    url = case build_query_string(opts) do
      "" -> tables_url(project_id, dataset_id)
      qs -> tables_url(project_id, dataset_id) <> "?" <> qs
    end

    case get(url) do
      {:ok, resp} ->
        if resp[:status_code] in 200..299 do
          list_resp = Poison.decode!(resp[:body], as: %TableList{})
          if list_resp.nextPageToken != nil do
            # TODO: THis isn't tail recursive...
            new_opts = Keyword.put(opts, :pageToken, list_resp.nextPageToken)
            more_tables = do_list_tables(project_id, dataset_id, new_opts)

            %{list_resp | tables: list_resp.tables ++ more_tables}
          else
            list_resp
          end
        else
          {:error, resp}
        end
      {:error, reason} ->
        {:error, "Error listing tables\n#{inspect reason}"}
    end
  end

  defp tables_url(project_id, dataset_id) do
    base_url() <> "/projects/" <> project_id <> "/datasets/" <> dataset_id <> "/tables"
  end

  defp table_url(project_id, dataset_id, table_id) do
    tables_url(project_id, dataset_id) <> "/" <> table_id
  end
end