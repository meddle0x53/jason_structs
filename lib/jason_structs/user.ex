defmodule Address do
  use Jason.Structs.Struct

  jason_struct do
    field(:city, String.t(), enforce: true)
  end
end

defmodule User do
  use Jason.Structs.Struct

  jason_struct do
    field(:name, String.t(), enforce: true)
    field(:age, integer(), enforce: true)
    field(:address, Address.t(), enforce: true)
    field(:interests, list(), excludable: true, default: [])
    field(:children, [User.t()], excludable: true, default: [])
  end
end
