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
