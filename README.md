# JasonStructs

A Jason plugin library that adds the ability to encode and decode structs to and from JSON.

Uses the brilliant library [Typed Struct](https://github.com/ejpcmac/typed_struct) to define a DSL
for defining structs convertable to JSON in Elixir.

It adds to [Jason](https://github.com/michalmuskala/jason) the ability to convert these types of structs.


## Installation

It is [available in Hex](https://hex.pm/docs/publish), so the package can be installed
by adding `jason_structs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jason_structs, "~> 0.1.0"}
  ]
end
```

## Examples

We can define structs like this (see the tests):

```elixir
defmodule Country do
  use Jason.Structs.Struct

  jason_struct do
    field(:code, String.t(), enforce: true)
    field(:name, String.t(), enforce: true)
  end
end

defmodule Address do
  use Jason.Structs.Struct

  jason_struct do
    field(:city, String.t(), enforce: true)
    field(:street_address_line_one, String.t(), enforce: true)
    field(:street_address_line_two, String.t(), enforce: false, excludable: true)
    field(:post_code, String.t(), enforce: false)
    field(:country, Country.t(), enforce: true)
  end
end

defmodule Interest do
  use Jason.Structs.Struct

  jason_struct do
    field(:name, String.t(), enforce: true)
    field(:description, String.t(), enforce: true)
  end
end

defmodule User do
  use Jason.Structs.Struct

  jason_struct do
    field(:name, String.t(), enforce: true)
    field(:age, integer(), enforce: true)
    field(:sex, :male | :female, enforce: true, default: :female)
    field(:address, Address.t(), enforce: true)
    field(:interests, list(), excludable: true, default: [])
    field(:children, [User.t()], excludable: true)
    field(:likes_json_structs, boolean(), default: true)
  end
end
```

And if we have instances of these structs like these:

```elixir
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
```

We can just do `{ok, json} = Jason.encode(pesho)` to get:

```json
{
  "address": {
    "city": "Yambol",
    "country": {
      "code": "bg",
      "name": "Bulgaria"
    },
    "postCode": "8600",
    "streetAddressLineOne": "jk. Graph Ignatiev",
    "streetAddressLineTwo": "bl. 72"
  },
  "age": 35,
  "children": [
    {
      "address": {
        "city": "Yambol",
        "country": {
          "code": "bg",
          "name": "Bulgaria"
        },
        "postCode": "8600",
        "streetAddressLineOne": "jk. Graph Ignatiev",
        "streetAddressLineTwo": "bl. 72"
      },
      "age": 10,
      "interests": [
        {
          "description": "A FPS!",
          "name": "Call Of Duty"
        },
        {
          "description": "Blocks and stuff!",
          "name": "Minecraft"
        }
      ],
      "likesJsonStructs": false,
      "name": "Ivan Petrov",
      "sex": "male"
    }
  ],
  "interests": [
    {
      "description": "Some people running after a ball and kicking it.",
      "name": "football"
    },
    {
      "description": "Alcoholic bevarage, very loved on the Balkans.",
      "name": "rakia"
    },
    {
      "description": "Obicham shopskata salata, mastika ledena da pia.",
      "name": "salata"
    }
  ],
  "likesJsonStructs": false,
  "name": "Petur Petrov",
  "sex": "male"
}
```

And don't forget : YAMBOL IS THE CITY!
