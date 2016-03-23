defmodule BigQuery.Mixfile do
  use Mix.Project

  def project do
    [app: :big_query,
     version: "0.0.1",
     name: "BigQuery",
     source_url: "https://github.com/jordan0day/big_query",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     docs: [extras: ["README.md"]],
     description: "A Google BigQuery API client.",
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison],
     mod: {BigQuery, []},
     env: [bigquery_private_key_path: "priv/bigquery_private_key.json"]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:jose, "1.4.2"},
      {:poison, "2.1.0"},
      {:httpoison, "0.8.2"},
      {:dialyze, "0.2.0", only: :dev},
      {:earmark, "0.2.1", only: :dev},
      {:ex_doc, "0.11.4", only: :dev}
    ]
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/jordan0day/big_query"}
    ]
  end
end
