defmodule JasonStructs.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :jason_structs,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      docs: [
        extras: ["README.md"],
        main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/meddle0x53/jason_structs"
      ],
      description:
        "A Jason plugin library that adds the ability to encode and decode structs to and from JSON",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:jason, "~> 1.1"},
      {:typed_struct, "~> 0.3.0"}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Nikolay Tsvetinov (Meddle)"],
      links: %{"GitHub" => "https://github.com/meddle0x53/jason_structs"}
    }
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
