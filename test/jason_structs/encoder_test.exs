defmodule Jason.Structs.EncoderTest do
  use ExUnit.Case

  setup do
    {:ok, %{user: DummyData.user()}}
  end

  test "encodes a Jason struct into valid JSON", %{user: user} do
    {:ok, encoded} = Jason.Structs.encode(user, pretty: true)

    {:ok, expected} = File.read("test/fixtures/pesho_encoded.json")

    assert encoded == String.trim(expected)
  end
end
