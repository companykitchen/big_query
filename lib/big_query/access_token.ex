defmodule BigQuery.AccessToken do
  @moduledoc """
  Retrieve a Google Cloud Access Token scoped to BigQuery
  """
  # Based on https://gist.github.com/plamb/8c8f39cfba9e69cb034a/871a9b8128117518cdfbbf46b4cd405b5353f6c6
  @spec get_token :: {:ok, String.t} | {:error, String.t}
  def get_token() do
    %{"private_key" => private_key, "client_email" => client_email} = key_data()
    jws = %{"alg" => "RS256"}
    jwk = JOSE.JWK.from_pem(private_key)

    header = %{
      "alg" => "RS256",
      "typ" => "JWT"
    }

    iat = :os.system_time(:seconds)
    exp = iat + 3600

    bigquery_scope = Application.get_env(:big_query, :bigquery_scope, "")
    claims = %{
      "iss" => client_email,
      "scope" => "#{bigquery_scope} https://www.googleapis.com/auth/bigquery.readonly https://www.googleapis.com/auth/bigquery.insertdata https://www.googleapis.com/auth/bigquery",
      "aud" => "https://www.googleapis.com/oauth2/v3/token",
      "exp" => exp,
      "iat" => iat
    }
    encoded_claims = JOSE.encode(claims)

    {_alg, compacted} = JOSE.JWS.sign(jwk, encoded_claims, header, jws)
                        |> JOSE.JWS.compact

    token_auth_uri = "https://www.googleapis.com/oauth2/v3/token"
    headers = %{"Content-type" => "application/x-www-form-urlencoded"}
    form = {:form, [assertion: compacted, grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"]}

    case HTTPoison.post(token_auth_uri, form, headers) do
      {:ok, response} ->
        body = JOSE.decode(response.body)
        {:ok, body["access_token"]}
      {:error, error} ->
        {:error, HTTPoison.Error.message(error)}
    end
  end

  defp key_data do
    key_file = Application.get_env(:big_query, :bigquery_private_key_path)

    data = if File.regular?(key_file) do
      File.read!(key_file)
    else
      Application.get_env(:big_query, :bigquery_private_key_data)
    end

    if data == nil do
      raise ArgumentError, message: "You must set big_query.bigquery_private_key_path or big_quer.bigquery_private_key_data"
    end

    JOSE.decode(data)
  end
end
