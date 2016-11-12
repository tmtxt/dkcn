defmodule ApiServer.AuthController do
  use ApiServer.Web, :controller
  import ApiServer.Util, only: [to_struct: 2]

  alias ApiServer.MainRepo, as: MainRepo
  alias ApiServer.Models.Main.User, as: MainUser

  alias ApiServer.AuthRepo, as: AuthRepo
  alias ApiServer.Models.Auth.User, as: AuthUser


  def get_user(conn, _params) do
    json conn, %{id_hello: "hello"}
  end


  @doc """
  Create new user in the system, both in auth db and main db
  """
  def create_user(conn, params) do
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
    result = to_camel_case(
      %{
        auth_user: auth_user,
        main_user: main_user
      }
    )
    json(conn, result)
  end

end
