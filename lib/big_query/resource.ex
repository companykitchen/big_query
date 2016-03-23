defmodule BigQuery.Resource do
  alias BigQuery.TokenServer
  alias HTTPoison.Response
  alias HTTPoison.Error

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