defmodule PTree.MixProject do
  use Mix.Project

  def project do
    [
      app: :ptree,
      name: "Prefix Tree",
      description: "An experimental and very simple implementation of prefix tree",
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: :ptree,
      description: "An experimental and very simple implementation of prefix tree",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mailcmd/ptree"},
      source_url: "https://github.com/mailcmd/ptree",
    ]    
  end
end
