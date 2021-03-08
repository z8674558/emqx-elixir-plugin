defmodule EmqxElixirPlugin.Mixfile do
  use Mix.Project

  def project do
    [
      app: :emqx_elixir_plugin,
      version: "git",
      elixir: "~> 1.10",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {EmqxElixirPlugin, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end
