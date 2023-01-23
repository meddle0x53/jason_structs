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

  def invoice do
    %Billing.Invoice{
      period: "01/23",
      due_date: "2023-01-31",
      items: [
        %Billing.InvoiceItem{
          name: "Video Game",
          unit_price: 60.0,
          quantity: 1,
          subtotal: 60.0,
        },
        %Billing.InvoiceItem{
          name: "Another Video Game",
          unit_price: 19.99,
          quantity: 1,
          subtotal: 19.99,
        }
      ],
      subtotal: 79.99
    }
  end

  def billing_account do
    %Billing.Account{
      id: "a:b-1",
      contact_name: "Some Company",
      contact_email: "contact@somecompany.com",
      billing_address: %Address{
        city: "Hill Valley, CA",
        street_address_line_one: "1640 Riverside Drive",
        post_code: "90999",
        country: %Country{
          code: "us",
          name: "United States of America"
        }
      },
      latest_invoice: invoice()
    }
  end
end
