defmodule Jason.Structs do
  alias Jason.Formatter

  @type encode_opt ::
          {:escape, :json | :unicode_safe | :html_safe | :javascript_safe}
          | {:maps, :naive | :strict}
          | {:pretty, boolean | Formatter.opts()}

  @spec encode(term, [encode_opt]) ::
          {:ok, String.t()} | {:error, EncodeError.t() | Exception.t()}
  defdelegate encode(term, encode_opts \\ []), to: Jason

  @spec encode!(term, [encode_opt]) :: String.t() | no_return
  defdelegate encode!(term, encode_opts \\ []), to: Jason

  @spec decode(iodata, atom) :: {:ok, term} | {:error, DecodeError.t()}
  defdelegate decode(bitstring_or_char_list, struct_module), to: Jason.Structs.Decoder

  @spec decode!(iodata, atom()) :: term | no_return
  def decode!(bitstring_or_char_list, struct_module) do
    case decode(bitstring_or_char_list, struct_module) do
      {:ok, result} -> result
      {:error, error} -> raise error
    end
  end
end
