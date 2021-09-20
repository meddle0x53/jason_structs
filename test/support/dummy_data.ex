defmodule DummyData do
  def country do
    %Country{
      code: "bg",
      name: "Bulgaria"
    }
  end

  def user do
    ivancho = %User{
      name: "Ivan Petrov",
      age: 10,
      sex: :male,
      address: %Address{
        city: "Yambol",
        street_address_line_one: "jk. Graph Ignatiev",
        street_address_line_two: "bl. 72",
        post_code: "8600",
        country: country()
      },
      interests: [
        %Interest{name: "Call Of Duty", description: "A FPS!"},
        %Interest{name: "Minecraft", description: "Blocks and stuff!"}
      ],
      likes_json_structs: false
    }

    %User{
      name: "Petur Petrov",
      age: 35,
      sex: :male,
      address: %Address{
        city: "Yambol",
        street_address_line_one: "jk. Graph Ignatiev",
        street_address_line_two: "bl. 72",
        post_code: "8600",
        country: country()
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
  end
end
