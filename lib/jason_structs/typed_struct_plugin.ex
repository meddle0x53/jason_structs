defmodule Jason.Structs.TypedStructPlugin do
  use TypedStruct.Plugin

  @impl true
  @spec init(keyword()) :: Macro.t()
  defmacro init(opts) do
    quote do
      Module.register_attribute(__MODULE__, :sub_structs, accumulate: true)
      Module.register_attribute(__MODULE__, :excludable_keys, accumulate: true)
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

    module =
      case type do
        {{:., _, [{:__aliases__, _, [atom]}, :t]}, _, _}
        when is_atom(atom) ->
          module = Module.concat([:"Elixir", atom])

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

    quote do
      unless is_nil(unquote(module)) do
        Module.put_attribute(__MODULE__, :sub_structs, {unquote(name), unquote(module)})
      end

      if unquote(is_excludable) == true do
        Module.put_attribute(__MODULE__, :excludable_keys, unquote(name))
      end
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

      Module.delete_attribute(__MODULE__, :excludable_keys)
      Module.delete_attribute(__MODULE__, :sub_structs)
    end
  end
end
