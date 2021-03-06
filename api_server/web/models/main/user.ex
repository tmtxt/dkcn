defmodule ApiServer.Models.Main.User do
  use ApiServer.Web, :model

  @derive {Poison.Encoder, except: [:__meta__]}
  @primary_key {:id, :id, [autogenerate: true]}

  schema "user" do
    field :name, :string
    field :auth_user_id, :integer
  end


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :auth_user_id])
    |> validate_required([:name, :auth_user_id])
    |> unique_constraint(:auth_user_id, name: "user_auth_user_id_unique")
  end

end
