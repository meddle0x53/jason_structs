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
    field(:interests, [Interest.t()], excludable: true, default: [])
    field(:children, [User.t()], excludable: true)
    field(:likes_json_structs, boolean(), default: true)
  end
end

defmodule Billing do
  defmodule InvoiceItem do
    use Jason.Structs.Struct

    jason_struct do
      field(:name, String.t(), enforce: true)
      field(:quantity, float(), enforce: true)
      field(:unit_price, float(), enforce: true)
      field(:subtotal, float(), enforce: true)
    end
  end

  defmodule Invoice do
    use Jason.Structs.Struct

    alias Billing.InvoiceItem, as: Item

    jason_struct do
      field(:period, String.t(), enforce: true)
      field(:due_date, String.t(), enforce: true)
      field(:items, [Item.t()], enforce: true)
      field(:subtotal, float(), enforce: true)
    end
  end

  defmodule Account do
    use Jason.Structs.Struct

    alias Billing.Invoice

    jason_struct do
      field(:id, String.t(), enforce: true)
      field(:contact_name, String.t(), enforce: true)
      field(:contact_email, String.t(), enforce: true)
      field(:billing_address, Address.t(), enforce: true)
      field(:latest_invoice, Invoice.t(), enforce: true)
    end
  end
end
