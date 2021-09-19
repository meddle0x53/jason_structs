defmodule Jason.Structs.Encoder do
  @moduledoc """
  Implementation that is applied to all the `Jason.Structs` structs.

  Basically it encodes the structs, defined with the DSL provided by `Jason.Structs` to JSON.
  By default all keys are transofrmed from snake-styled expressions to cammel-styled expressions.
  """
  alias Jason.Encoder

  @typep escape :: (String.t(), String.t(), integer() -> iodata())
  @typep encode_map :: (map(), escape(), encode_map() -> iodata())
  @opaque opts :: {escape(), encode_map()}

  @doc """
  Implements the Jason.Encoder.encode function for `Jason.Structs` structs.
  """
  @spec encode(data :: Map.t(), opts()) :: iodata()
  def encode(data, options) do
    module = Map.get(data, :__struct__)
    to_exclude_if_nil = Kernel.apply(module, :excludable_keys, [])

    data =
      Enum.reduce(to_exclude_if_nil, data, fn key, acc ->
        if is_nil(Map.get(acc, key)) do
          Map.delete(acc, key)
        else
          acc
        end
      end)

    data = Map.delete(data, :__struct__)

    data =
      data
      |> Enum.map(fn {key, value} ->
        {key |> Atom.to_string() |> camelize(), value}
      end)
      |> Map.new()

    Encoder.Map.encode(data, options)
  end

  defp camelize(str) do
    str = Macro.camelize(str)
    first = str |> String.slice(0..0) |> String.downcase()

    first <> String.slice(str, 1..-1)
  end
end
