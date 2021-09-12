defmodule Jason.Structs.Decoder do
  def decode(json, struc_module \\ nil) do
    case Jason.decode(json) do
      {:ok, map} ->
        map
        |> keys_to_snake_style_atoms()
        |> to_struct(struc_module)

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
        Map.put_new(acc, key, to_struct(value, Map.get(struc_module.sub_structs(), key)))
      end)

    struct(struc_module, updated_map)
  end

  defp to_struct(list, struc_module) when is_list(list) and is_atom(struc_module) do
    Enum.map(list, fn entry -> to_struct(entry, struc_module) end)
  end

  defp to_struct(value, _), do: value
end
