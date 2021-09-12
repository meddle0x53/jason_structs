defmodule Jason.Structs.Struct do
  @doc false
  defmacro __using__(_) do
    quote do
      use TypedStruct
      import Jason.Structs.Struct, only: [jason_struct: 1]

      defimpl Jason.Encoder, for: [__MODULE__] do
        @impl true
        def encode(data, options) do
          Jason.Structs.Encoder.encode(data, options)
        end
      end
    end
  end

  defmacro jason_struct(body) do
    quote do
      typedstruct do
        plugin(Jason.Structs.TypedStructPlugin, this: __MODULE__)

        unquote(body)
      end
    end
  end
end
