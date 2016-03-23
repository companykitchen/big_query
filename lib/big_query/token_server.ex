defmodule BigQuery.TokenServer do
  use GenServer

  alias BigQuery.AccessToken

  @max_tries 5

  # Client API
  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, [], opts)

  @spec get_token() :: {:ok, String.t} | {:error, String.t}
  def get_token() do
    GenServer.call(TokenServer, :get_token)
  end

  def stop(reason \\ :normal) do
    GenServer.stop(TokenServer, reason)
  end

  # Server API
  def init(_args) do
    {:ok, {nil, nil}}
  end

  def handle_call(:get_token, _from, {token, expiration} = state) do
    if is_valid(expiration) do
      {:reply, {:ok, token}, state}
    else
      # Token is expired, fetch a new one
      case fetch_token() do
        {:ok, token} ->
          now = :erlang.system_time(:seconds)
          # BigQuery tokens expire after 3600 seconds. Use 3500 to give
          # a little wiggle room
          {:reply, {:ok, token}, {token, now + 3500}}
        error -> error
      end
    end
  end

  defp is_valid(nil), do: false

  defp is_valid(expiration) do
    now = :erlang.system_time(:seconds)

    expiration > now
  end

  @spec fetch_token(integer) :: {:ok, String.t} | {:error, String.t}
  defp fetch_token(tries \\ 0) do
    case AccessToken.get_token() do
      {:ok, token} -> {:ok, token}
      {:error, reason} ->
        if tries < @max_tries do
          fetch_token(tries + 1)
        else
          {:error, reason}
        end
    end
  end
end