# BigQuery

An Elixir client for the Google BigQuery API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

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
