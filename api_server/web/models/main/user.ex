defmodule ApiServer.Models.Main.User do
  use Ecto.Schema

  @primary_key {:id, :id, [autogenerate: true]}

  schema "user" do
    field :name, :string
    field :auth_user_id, :integer
  end

end
