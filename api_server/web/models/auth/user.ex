defmodule ApiServer.Models.Auth.User do
  use Ecto.Schema

  @derive {Poison.Encoder, except: [:__meta__]}
  @primary_key {:id, :id, [autogenerate: true]}

  schema "user" do
    field :username, :string
    field :email, :string
    field :password, :string
  end

end
