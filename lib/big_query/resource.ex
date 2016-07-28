defmodule BigQuery.Resource do
  alias BigQuery.TokenServer

  @type headers :: [{String.t, String.t}]
  @type response :: %{status_code: integer, body: String.t, headers: headers}

  defmacro __using__(_opts) do
    quote do
      @bigquery_url "https://www.googleapis.com/bigquery/v2"

      import BigQuery.Resource

      @doc false
      def base_url(), do: @bigquery_url
    end
  end

  @spec get(String.t, headers, [timeout: integer]) :: {:ok, response} | {:error, String.t}
  def get(url, headers \\ [], opts \\ [timeout: 120_000]) do
    case TokenServer.get_token() do
      {:ok, access_token} ->
        headers = headers
                  |> add_auth_header(access_token)
                  |> add_header("Content-Type", "application/json")

        case HTTPoison.get(url, headers, recv_timeout: opts[:timeout]) do
          {:error, error} ->
            {:error, inspect error.reason}
          {:ok, resp} -> {:ok, Map.from_struct(resp)}
        end
      error -> error
    end
  end

  @spec post(String.t, any, [{String.t, String.t}], [timeout: integer]) :: {:ok, response} | {:error, String.t}
  def post(url, body \\ nil, headers \\ [], opts \\ [timeout: 120_000]) do
    case TokenServer.get_token() do
      {:ok, access_token} ->
        headers = headers
                  |> add_auth_header(access_token)
                  |> add_header("Content-Type", "application/json")

        {:ok, encoded_body} = Poison.encode(body)

        case HTTPoison.post(url, encoded_body, headers, timeout: opts[:timeout], recv_timeout: opts[:timeout]) do
          {:error, error} ->
            {:error, inspect error.reason}
          {:ok, resp} -> {:ok, Map.from_struct(resp)}
        end
    end
  end


  @spec delete(String.t, [{String.t, String.t}], [timeout: integer]) :: {:ok, response} | {:error, String.t}
  def delete(url, headers \\ [], opts \\ [timeout: 120_000]) do
    case TokenServer.get_token() do
      {:ok, access_token} ->
        headers = headers
                  |> add_auth_header(access_token)
                  |> add_header("Content-Type", "application/json")

        case HTTPoison.delete(url, headers, timeout: opts[:timeout], recv_timeout: opts[:timeout]) do
         {:error, error} ->
           {:error, inspect error.reason}
         {:ok, resp} -> {:ok, Map.from_struct(resp)}
        end
    end
  end

  @doc """
  BigQuery really doesn't like if when you try to POST a JSON object that has
  null values, but doesn't seem to mind missing fields.
  So this is just a little helper function to remove any fields with a nil
  value from a map/struct.
  """
  @spec clean_up_map(map()) :: map()
  def clean_up_map(%{__struct__: _struct} = map) do
    map
    |> Map.from_struct
    |> clean_up_map
  end

  def clean_up_map(map) do
    map
    |> Enum.filter(fn ({_k, v}) -> v != nil end)
    |> Enum.map(fn ({k, v}) -> {k, clean_map_field(v)} end)
    |> Enum.into(%{})
  end

  defp clean_map_field(map) when is_map(map), do: clean_up_map(map)
  defp clean_map_field(list) when is_list(list), do: Enum.map(list, &clean_map_field/1)
  defp clean_map_field(v), do: v

  @spec build_query_string([{String.t | atom, any}]) :: String.t
  def build_query_string(params) do
    params
    |> Enum.filter(fn ({_k, v}) -> v != nil end)
    |> URI.encode_query
  end

  defp add_auth_header(headers, access_token) do
    add_header(headers, "Authorization", "Bearer #{access_token}")
  end

  defp add_header(headers, header_name, header_value) do
    # don't overwrite an existing header
    case List.keyfind(headers, header_name, 0) do
      nil ->
        [{header_name, header_value}] ++ headers
      _ -> headers
    end
  end
end