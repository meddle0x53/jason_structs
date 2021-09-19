defmodule Jason.Structs.EncoderTest do
  use ExUnit.Case

  setup do
    ivancho = %User{
      name: "Ivan Petrov",
      age: 10,
      sex: :male,
      address: %Address{
        city: "Yambol",
        street_address_line_one: "jk. Graph Ignatiev",
        street_address_line_two: "bl. 72",
        post_code: "8600",
        country: %Country{
          code: :bg,
          name: "Bulgaria"
        }
      },
      interests: [
        %Interest{name: "Call Of Duty", description: "A FPS!"},
        %Interest{name: "Minecraft", description: "Blocks and stuff!"}
      ],
      likes_json_structs: false
    }

    pesho = %User{
      name: "Petur Petrov",
      age: 35,
      sex: :male,
      address: %Address{
        city: "Yambol",
        street_address_line_one: "jk. Graph Ignatiev",
        street_address_line_two: "bl. 72",
        post_code: "8600",
        country: %Country{
          code: :bg,
          name: "Bulgaria"
        }
      },
      interests: [
        %Interest{
          name: "football",
          description: "Some people running after a ball and kicking it."
        },
        %Interest{name: "rakia", description: "Alcoholic bevarage, very loved on the Balkans."},
        %Interest{name: "salata", description: "Obicham shopskata salata, mastika ledena da pia."}
      ],
      children: [ivancho],
      likes_json_structs: false
    }

    {:ok, %{user: pesho}}
  end

  test "encodes a Jason struct into valid JSON", %{user: user} do
    {:ok, encoded} = Jason.Structs.encode(user, pretty: true)

    {:ok, expected} = File.read("test/fixtures/pesho_encoded.json")

    assert encoded == String.trim(expected)
  end
end
