defmodule Jason.Structs.DecoderTest do
  use ExUnit.Case

  alias Jason.Structs.Decoder

  test "decodes a JSON into a Jason struct" do
    {:ok, json} = File.read("test/fixtures/pesho_encoded.json")

    {:ok, user} = Decoder.decode(json, User)

    assert user == DummyData.user()
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
