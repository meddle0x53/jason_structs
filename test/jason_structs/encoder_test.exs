defmodule Jason.Structs.EncoderTest do
  use ExUnit.Case

  setup do
    {:ok, %{user: DummyData.user(), billing_account: DummyData.billing_account()}}
  end

  test "encodes a Jason struct into valid JSON", %{user: user} do
    {:ok, encoded} = Jason.Structs.encode(user, pretty: true)

    {:ok, expected} = File.read("test/fixtures/pesho_encoded.json")

    assert encoded == String.trim(expected)
  end

  test "encodes a Jason struct with namespaced substructs into valid JSON", %{
    billing_account: billing_account
  } do
    {:ok, encoded} = Jason.Structs.encode(billing_account, pretty: true)

    {:ok, expected} = File.read("test/fixtures/billing_account_encoded.json")

    assert encoded == String.trim(expected)
  end
end
