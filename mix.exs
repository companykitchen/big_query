defmodule BigQuery.Mixfile do
  use Mix.Project

  def project do
    [app: :big_query,
     version: "0.0.11",
     name: "BigQuery",
     source_url: "https://github.com/companykitchen/big_query",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [extras: ["README.md"]],
     description: "A Google BigQuery API client.",
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :jose, :httpoison, :poison],
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
      {:jose, "~> 1.8"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.11.1"},
      {:dialyxir, "~> 0.5.0", only: :dev},
      {:earmark, "~> 1.2.0", only: :dev},
      {:ex_doc, "~> 0.15.0", only: :dev}
    ]
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/companykitchen/big_query"},
      maintainers: ["Jordan Day"]
    ]
  end
end
