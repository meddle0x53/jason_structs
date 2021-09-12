defmodule Jason.Structs.Encoder do
  alias Jason.Encoder

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
