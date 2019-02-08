defmodule ReTags.MixProject do
  use Mix.Project

  def project do
    [
      app: :re_tags,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
  end

  def application do
    [
      mod: {ReTags.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:postgrex, "~> 0.13"},
      {:eventstore, "~> 0.15"},
      {:timber, "~> 3.0.0"},
      {:commanded, "~> 0.17"},
      {:commanded_eventstore_adapter, "~> 0.4"},
      {:commanded_ecto_projections, "~> 0.7"},
      {:exconstructor, "~> 1.1"},
      {:vex, "~> 0.6"},
      {:ex_machina, "~> 2.2", only: :test}
    ]
  end

  defp aliases do
    [
      "event_store.reset": ["event_store.drop", "event_store.create", "event_store.init"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      setup: [
        "event_store.create --quiet",
        "event_store.init --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet"
      ],
      reset: ["event_store.drop", "ecto.drop", "setup"],
      test: ["setup", "test"]
    ]
  end
end
