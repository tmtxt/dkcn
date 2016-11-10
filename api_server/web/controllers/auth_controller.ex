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
    json conn, %{id_hello: "hello"}
  end


  @doc """
  Create new user in the system, both in auth db and main db
  """
  def create_user(conn, params) do
    IO.inspect(params)

    # insert user in auth db
    auth_user = to_struct %AuthUser{}, params
    {:ok, auth_user} = AuthRepo.insert(auth_user)

    # insert user in main db
    %{ username: username } = auth_user
    main_user = %MainUser{
      name: username
    }
    {:ok, main_user} = MainRepo.insert(main_user)

    # response
    json conn, %{
      auth_user: auth_user,
      main_user: main_user
    }
  end

end
