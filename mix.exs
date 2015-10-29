defmodule Zen.Mixfile do
  use Mix.Project

  def project do
    [app: :zen,
     version: "0.0.1",
     elixir: "~> 1.1",
     escript: escript,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def escript do
    [main_module: Zen]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:git_cli, "~> 0.1.0"},
     {:dogma, "~> 0.0", only: :dev}]
  end
end
