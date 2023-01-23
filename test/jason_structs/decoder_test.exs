defmodule Jason.Structs.DecoderTest do
  use ExUnit.Case

  alias Jason.Structs.Decoder

  test "decodes a JSON into a Jason struct" do
    {:ok, json} = File.read("test/fixtures/pesho_encoded.json")

    {:ok, user} = Decoder.decode(json, User)

    assert user == DummyData.user()
  end

  test "decodes a JSON into a Jason struct with namespaced substructs" do
    {:ok, json} = File.read("test/fixtures/billing_account_encoded.json")

    # make sure that the modules are loaded so we don't run into issues with
    # :erlang.binary_to_existing_atom during parse
    Code.ensure_loaded!(Billing.Account)
    Code.ensure_loaded!(Billing.Invoice)
    Code.ensure_loaded!(Billing.InvoiceItem)

    {:ok, account} = Decoder.decode(json, Billing.Account)

    assert account == DummyData.billing_account()
  end

  test "decodes a JSON into a map if a struct is not passed" do
    {:ok, json} = File.read("test/fixtures/pesho_encoded.json")

    {:ok, user} = Decoder.decode(json)

    assert user == %{
             address: %{
               city: "Yambol",
               country: %{code: "bg", name: "Bulgaria"},
               post_code: "8600",
               street_address_line_one: "jk. Graph Ignatiev",
               street_address_line_two: "bl. 72"
             },
             age: 35,
             children: [
               %{
                 address: %{
                   city: "Yambol",
                   country: %{code: "bg", name: "Bulgaria"},
                   post_code: "8600",
                   street_address_line_one: "jk. Graph Ignatiev",
                   street_address_line_two: "bl. 72"
                 },
                 age: 10,
                 interests: [
                   %{description: "A FPS!", name: "Call Of Duty"},
                   %{description: "Blocks and stuff!", name: "Minecraft"}
                 ],
                 likes_json_structs: false,
                 name: "Ivan Petrov",
                 sex: "male"
               }
             ],
             interests: [
               %{
                 description: "Some people running after a ball and kicking it.",
                 name: "football"
               },
               %{
                 description: "Alcoholic bevarage, very loved on the Balkans.",
                 name: "rakia"
               },
               %{
                 description: "Obicham shopskata salata, mastika ledena da pia.",
                 name: "salata"
               }
             ],
             likes_json_structs: false,
             name: "Petur Petrov",
             sex: "male"
           }
  end
end
