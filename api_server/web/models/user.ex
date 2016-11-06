defmodule ApiServer.Models.User do
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "user" do
    field :username, :string
    field :email, :string
  end

end
