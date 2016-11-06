defmodule ApiServer.AuthController do
  use ApiServer.Web, :controller
  import ApiServer.AuthRepo, only: [insert: 1]
  alias ApiServer.Models.User, as: User

  def get_user(conn, _params) do
    user = %User{username: "truong2", email: "test2"}
    {:ok, user} = insert(user)
    IO.inspect user
    json conn, %{id: "hello"}
  end
end
