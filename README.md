# BigQuery

An Elixir client for the Google BigQuery API.

**DEPRECATED**

Now that an official(*ish*) Google BigQuery API client is available at [https://github.com/googleapis/elixir-google-api/tree/master/clients/big_query](https://github.com/googleapis/elixir-google-api/tree/master/clients/big_query), you should probably be using it instead.

## Installation

BigQuery is [available in Hex](https://hex.pm/packages/big_query). The package can be installed as:

  1. Add big_query to your list of dependencies in `mix.exs`:

         def deps do
           [{:big_query, "~> 0.0.1"}]
         end

  2. Ensure big_query is started before your application:

         def application do
           [applications: [:big_query]]
         end

  3. Configure the location of your BigQuery private key .json file:

         config :big_query,
           bigquery_private_key_path: "path/to/private_key.json"

  4. If you need ask for special scopes - configure them:

         config :big_query,
           bigquery_scope: "https://www.googleapis.com/auth/drive"

  5. If you have long running requests - you can override the timeout of the http calls (in MS):

         config :big_query,
           bigquery_request_timeout: 60000
