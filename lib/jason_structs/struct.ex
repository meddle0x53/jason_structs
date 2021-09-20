defmodule Jason.Structs.Struct do
  @moduledoc """
  This module defines the `jason_struct` macro, which can be used to define
  a struct convertable to JSON and decodable from JSON.

  An example of such a module could be:

      defmodule Country do
        use Jason.Structs.Struct

        jason_struct do
          field(:code, String.t(), enforce: true)
          field(:name, String.t(), enforce: true)
        end
      end

  Here we `use Jason.Structs.Struct` and now we can define the struct, using the `jason_struct` macro.
  This will change the module to look like this:

      defmodule Country do
        @type t() :: %Country{code: String.t(), name: String.t()}

        @enforce_keys [:code, :name]
        defstruct code: nil, name: nil
      end

  Note that the macro generates some functions that are used by the encoding and decoding logic and they
  are excluded from this example.

  It is possible to define structs, referencing other `Jason.Structs` structs:

      defmodule Address do
        use Jason.Structs.Struct

        jason_struct do
          field(:city, String.t(), enforce: true)
          field(:street_address_line_one, String.t(), enforce: true)
          field(:street_address_line_two, String.t(), enforce: false, excludable: true)
          field(:country, Country.t(), enforce: true)
        end
      end

  Here we are defining a `country` field of type `Country.t()` this will work fine.

  It is possible to have recursive references and references in lists:

      defmodule User do
        use Jason.Structs.Struct

        jason_struct do
          field(:name, String.t(), enforce: true)
          field(:address, Address.t(), enforce: true)
          field(:children, [User.t()], excludable: true)
        end
      end

  The `User` can have a list of children of type `User`.

  With these definitions if we try to decode (`Jason.Structs.decode!(json_string, User)`) the following JSON:

      {
        "address": {
          "city": "Yambol",
          "country": {
            "code": "bg",
            "name": "Bulgaria"
          },
          "streetAddressLineOne": "jk. Graph Ignatiev"
        },
        "children": [
          {
            "address": {
              "city": "Yambol",
              "country": {
                "code": "bg",
                "name": "Bulgaria"
              },
              "streetAddressLineOne": "jk. Graph Ignatiev"
            },
            "name": "Ivan Petrov"
          }
        ],
        "name": "Petur Petrov"
      }

  We'll get the following struct instance:

      %User{
        address: %Address{
          city: "Yambol",
          country: %Country{code: "bg", name: "Bulgaria"},
          street_address_line_one: "jk. Graph Ignatiev",
          street_address_line_two: nil
        },
        children: [
          %User{
            address: %Address{
              city: "Yambol",
              country: %Country{code: "bg", name: "Bulgaria"},
              street_address_line_one: "jk. Graph Ignatiev",
              street_address_line_two: nil 
            },
            children: nil,
            name: "Ivan Petrov"
          }
        ],
        name: "Petur Petrov"
      }

  By using this `Jason.Structs.Struct`, the module using it will also get special `Jason.Encoder` implementation,
  so it will be possible to encode it with `Jason.encode(struct_instance)`.
  """

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

  @doc """
  Defines a `Jason.Structs` struct.

  As this library uses [Typed Struct](https://github.com/ejpcmac/typed_struct) for the implementation,
  every field defined in the body of the macro supports the options supported by `TypedStruct.typedstruct/2`.

  Options for the fields:

    * `enforce` - if set to true, add this field to the `@enforce_keys` list.
    * `excludable` - if the value of the field is `nil`, when the struct is encoded into JSON, the field is excluded.
    * `default` - a default value for the field, if it is not set to something else.

  ## Example

        jason_struct do
          field(:name, String.t(), enforce: true, default: "Petar")
          field(:address, Address.t(), enforce: true)
          field(:children, [User.t()], excludable: true)
        end

  """
  defmacro jason_struct(body) do
    quote do
      typedstruct do
        plugin(Jason.Structs.TypedStructPlugin, this: __MODULE__)

        unquote(body)
      end
    end
  end
end
