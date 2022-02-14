defmodule Bark.Mixfile do
  use Mix.Project

  def project do
    [app: :bark,
     version: "0.0.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     dialyzer: [plt_add_deps: :transitive]]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    []
  end
end
