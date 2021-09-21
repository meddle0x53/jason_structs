defmodule Jason.Structs do
  @moduledoc """
  The main module of `Jason.Structs`.

  It provides functions for encoding and decoding JSON to and from structs.

  The `encode` functions are basically delegating to `Jason.encode`, as the `Jason.Encoder`
  is automatically implemented for all `Jason.Structs.Struct` modules.

  The `decode` functions are delegating to `Jason.Structs.Decoder`.

  We can have:

      defmodule Country do
        use Jason.Structs.Struct

        jason_struct do
          field(:code, String.t(), enforce: true)
          field(:name, String.t(), enforce: true)
        end
      end

  this is a `Jason.Structs.Struct` now, so if we have the following JSON:

      json = ~s(
        {
          "code": "bg",
          "name": "Bulgaria"
        }
      )

  By using:

      Jason.Structs.decode!(json, Country)

  we get:

      %Country{code: "bg", name: "Bulgaria"}

  And we can convert

      country = %Country{code: "bg", name: "Bulgaria"}

  to JSON like this:

      country |> Jason.Structs.encode!(pretty: true) |> IO.puts()
      {
        "code": "bg",
        "name": "Bulgaria"
      }
  """

  @doc """
  Generates JSON corresponding to the `input`.

  See [Jason.encode/2](https://hexdocs.pm/jason/Jason.html#encode/2) for more information,
  as it delegates to it.

  The `Jason.Structs.Struct` structs automatically implement the `Jason.Encoder` protocol with
  a custom implementation, so all of them can be encoded to JSON.

  Examples

      defmodule Country do
        use Jason.Structs.Struct

        jason_struct do
          field(:code, String.t(), enforce: true)
          field(:name, String.t(), enforce: true)
        end
      end

      iex> country = %Country{code: "bg", name: "Bulgaria"}
      iex> Jason.Structs.encode(country)
      {:ok, ~s({"code":"bg","name":"Bulgaria"})}
  """
  @spec encode(term(), [Jason.encode_opt()]) ::
          {:ok, String.t()} | {:error, EncodeError.t() | Exception.t()}
  defdelegate encode(input, encode_opts \\ []), to: Jason

  @doc """
  Generates JSON corresponding to input.

  Similar to `encode/1` except it will unwrap the error tuple and raise in case of errors.

  See [Jason.encode!/2](https://hexdocs.pm/jason/Jason.html#encode!/2) for more information,
  as it delegates to it.

  The `Jason.Structs.Struct` structs automatically implement the `Jason.Encoder` protocol with
  a custom implementation, so all of them can be encoded to JSON.

  Examples

      defmodule Country do
        use Jason.Structs.Struct

        jason_struct do
          field(:code, String.t(), enforce: true)
          field(:name, String.t(), enforce: true)
        end
      end

      iex> country = %Country{code: "bg", name: "Bulgaria"}
      iex> Jason.Structs.encode!(country)
      ~s({"code":"bg","name":"Bulgaria"})
  """
  @spec encode!(term(), [Jason.encode_opt()]) :: String.t() | no_return()
  defdelegate encode!(term, encode_opts \\ []), to: Jason

  @doc """
  Parses a JSON value from input iodata and if a `struct_module` is provided,
  which is a `Jason.Structs.Struct` implementation, the parsed result will be an
  instance of that struct.

  By skipping the `struct_module` it works like the normal `Jason.decode` function.
  It can parse all valid JSON values that way (numbers, lists, booleans, objects, strings, null).

  Examples

      defmodule Country do
        use Jason.Structs.Struct

        jason_struct do
          field(:code, String.t(), enforce: true)
          field(:name, String.t(), enforce: true)
        end
      end

      iex> json = ~s({"name": "Bulgaria", "code": "bg"})
      iex> Jason.Structs.decode(json, Country)
      {:ok, %Country{code: "bg", name: "Bulgaria"}}

      iex> json = ~s({"name": "Bulgaria", "code": "bg"})
      iex> Jason.Structs.decode(json)
      {:ok, %{code: "bg", name: "Bulgaria"}}

      iex> json = "55"
      iex> Jason.Structs.decode(json)
      {:ok, 55}

      iex> Jason.Structs.decode("invalid")
      {:error, %Jason.DecodeError{data: "invalid", position: 0, token: nil}}
  """
  @spec decode(iodata(), atom()) :: {:ok, term()} | {:error, DecodeError.t()}
  defdelegate decode(iodata, struct_module \\ nil), to: Jason.Structs.Decoder

  @doc """
  Parses a JSON value from input iodata and if a `struct_module` is provided,
  which is a `Jason.Structs.Struct` implementation, the parsed result will be an
  instance of that struct.

  Similar to `decode/2` except it will unwrap the error tuple and raise in case of errors.

  By skipping the `struct_module` it works like the normal `Jason.decode!` function.
  It can parse all valid JSON values that way (numbers, lists, booleans, objects, strings, null).

  Examples

      defmodule Country do
        use Jason.Structs.Struct

        jason_struct do
          field(:code, String.t(), enforce: true)
          field(:name, String.t(), enforce: true)
        end
      end

      iex> json = ~s({"name": "Bulgaria", "code": "bg"})
      iex> Jason.Structs.decode!(json, Country)
      %Country{code: "bg", name: "Bulgaria"}

      iex> json = ~s({"name": "Bulgaria", "code": "bg"})
      iex> Jason.Structs.decode!(json)
      %{code: "bg", name: "Bulgaria"}

      iex> Jason.Structs.decode!("true")
      true

      iex> Jason.Structs.decode!("invalid")
      ** (Jason.DecodeError) unexpected byte at position 0: 0x69 ('i')
  """
  @spec decode!(iodata(), atom()) :: term() | no_return()
  def decode!(iodata, struct_module \\ nil) do
    case decode(iodata, struct_module) do
      {:ok, result} -> result
      {:error, error} -> raise error
    end
  end
end
