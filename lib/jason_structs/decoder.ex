defmodule Jason.Structs.Decoder do
  @moduledoc """
  A JSON Decoder that can decode a JSON to a `Jason.Structs` struct, if its modul is provided.

  The decoding process is recursive and if the strcut has fields that are `Jason.Structs` structs,
  they are also decoded.

  If the struct has fields, that are normal structs they'll be decoded as maps.
  """

  @doc """
  Decods the passed iodata JSON to a struct of the given `struc_module` type.

  If the `struc_module` is passed as `nil`, the result is just a map.
  """
  @spec decode(json :: iodata(), struc_module :: module() | nil) ::
          {:ok, map()} | {:error, term()}
  def decode(json, struc_module \\ nil) do
    case Jason.decode(json) do
      {:ok, map} ->
        result =
          map
          |> keys_to_snake_style_atoms()
          |> to_struct(struc_module)

        {:ok, result}

      {:error, _} = error ->
        error
    end
  end

  defp keys_to_snake_style_atoms(map) when is_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      new_key = key |> Macro.underscore() |> String.to_existing_atom()
      new_value = keys_to_snake_style_atoms(value)

      Map.put_new(acc, new_key, new_value)
    end)
  end

  defp keys_to_snake_style_atoms(list) when is_list(list) do
    Enum.map(list, fn entry -> keys_to_snake_style_atoms(entry) end)
  end

  defp keys_to_snake_style_atoms(value), do: value

  defp to_struct(value, nil), do: value

  defp to_struct(map, struc_module) when is_map(map) and is_atom(struc_module) do
    updated_map =
      Enum.reduce(map, %{}, fn {key, value}, acc ->
        struct_m = Map.get(struc_module.sub_structs(), key)
        type_info = Map.get(struc_module.type_data(), key)

        Map.put_new(acc, key, to_struct(value, struct_m || type_info))
      end)

    struct(struc_module, updated_map)
  end

  defp to_struct(list, struc_module) when is_list(list) and is_atom(struc_module) do
    Enum.map(list, fn entry -> to_struct(entry, struc_module) end)
  end

  # TODO validation
  defp to_struct(value, {:enum, _values}) do
    String.to_existing_atom(value)
  end

  defp to_struct(value, _), do: value
end
