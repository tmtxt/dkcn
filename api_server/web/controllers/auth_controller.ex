defmodule ApiServer.AuthController do
  use ApiServer.Web, :controller
  import ApiServer.Util, only: [to_struct: 2]

  alias ApiServer.MainRepo, as: MainRepo
  alias ApiServer.Models.Main.User, as: MainUser

  alias ApiServer.AuthRepo, as: AuthRepo
  alias ApiServer.Models.Auth.User, as: AuthUser

  def get_user(conn, _params) do
    # user = %User{username: "truong3", email: "test3"}
    # {:ok, user} = insert(user)
    # IO.inspect user
    json conn, %{id: "hello"}
  end

  def create_user(conn, params) do
    try do
      # insert user in auth db
      # auth_user = to_struct %AuthUser{}, params
      # {:ok, auth_user} = AuthRepo.insert(auth_user)

      # # insert user in main db
      # %{ username: username } = auth_user
      # main_user = %MainUser{
      #   name: username
      # }
      # {:ok, main_user} = MainRepo.insert(main_user)

      json conn, %{hello: "abc"}
    rescue
      err in Ecto.ConstraintError -> conn
      |> put_status(400)
      |> json(%{message: "Constraint error"})
    end

  end

end
