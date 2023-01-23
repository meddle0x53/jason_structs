defmodule Jason.Structs.TypedStructPlugin do
  @moduledoc """
  A [Typed Struct](https://github.com/ejpcmac/typed_struct) plugin, used to customize
  a definition of a `TypedStruct`.

  This plugin converts a `TypedStruct` into a `Jason.Structs.Struct` by adding
  specific properties and functions needed for JSON encoding and decoding.

  This plugin is applied automatically to any module with the expression `use Jason.Structs.Struct` in it.
  """
  use TypedStruct.Plugin

  @impl true
  @spec init(keyword()) :: Macro.t()
  defmacro init(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :sub_structs, accumulate: true)
      Module.register_attribute(__MODULE__, :excludable_keys, accumulate: true)
      Module.register_attribute(__MODULE__, :types_info, accumulate: true)

      aliases =
        __ENV__.aliases
        |> Enum.map(fn {the_alias, module_path} ->
          {the_alias |> Module.split() |> Enum.at(0), module_path |> Module.split()}
        end)
        |> Map.new()

      Module.put_attribute(__MODULE__, :aliases, aliases)
    end
  end

  @impl true
  @spec field(atom(), any(), keyword()) :: Macro.t()
  def field(name, type, opts) do
    type =
      if is_list(type) and Enum.count(type) == 1 do
        List.first(type)
      else
        type
      end

    aliases = Module.get_attribute(opts[:this], :aliases, [])

    module =
      case type do
        {{:., _, [{:__aliases__, _, module_path}, :t]}, _, _}
        when is_list(module_path) ->
          module = dealias_module_path(module_path, aliases)

          if module == opts[:this] do
            module
          else
            functions = module.__info__(:functions)

            if Enum.member?(functions, {:sub_structs, 0}) do
              module
            else
              nil
            end
          end

        _ ->
          nil
      end

    is_excludable = opts[:excludable]

    type_data =
      case type do
        {{:., _, [{:__aliases__, _, module_path}, :t]}, _, _} ->
          {:struct, module_path}

        {:|, _, values} ->
          if Enum.all?(values, &is_atom/1) do
            {:enum, values}
          else
            # TODO a sum type
            {:sum, values}
          end

        {simple_type, _, _} ->
          {:simple_type, simple_type}
      end

    quote do
      unless is_nil(unquote(module)) do
        Module.put_attribute(__MODULE__, :sub_structs, {unquote(name), unquote(module)})
      end

      if unquote(is_excludable) == true do
        Module.put_attribute(__MODULE__, :excludable_keys, unquote(name))
      end

      Module.put_attribute(__MODULE__, :types_info, {unquote(name), unquote(type_data)})
    end
  end

  @impl true
  @spec after_definition(opts :: keyword()) :: Macro.t()
  def after_definition(_opts) do
    quote do
      def sub_structs do
        Map.new(@sub_structs)
      end

      def excludable_keys do
        @excludable_keys
      end

      def type_data do
        Map.new(@types_info)
      end

      Module.delete_attribute(__MODULE__, :types_info)
      Module.delete_attribute(__MODULE__, :excludable_keys)
      Module.delete_attribute(__MODULE__, :sub_structs)
      Module.delete_attribute(__MODULE__, :aliases)
    end
  end

  def dealias_module_path([module_name], aliases) do
    actual_path =
      aliases
      |> Map.get(Atom.to_string(module_name), [module_name])

    Module.concat([Enum.join(actual_path, ".")])
  end

  def dealias_module_path(path, _), do: Module.concat([:"Elixir" | path])
end
