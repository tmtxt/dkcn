defmodule ApiServer.Services.Auth do

  alias ApiServer.MainRepo
  alias ApiServer.AuthRepo
  alias ApiServer.Models.Main.User, as: MainUser
  alias ApiServer.Models.Auth.User, as: AuthUser
  import Ecto.Query

  @typedoc """
  Context data type for logging
  """
  @type context :: %{log_trace: map}


  @doc """
  Create auth user and main user
  Throw Ecto.Changeset if not success

  Return a map with 2 keys `auth_user` and `main_user`
  """
  @spec create_both_user(context, map) :: map
  def create_both_user(conn, user_data) do
    # insert user in auth db
    auth_user = AuthUser.changeset(%AuthUser{}, user_data)
    auth_user = case AuthRepo.insert(auth_user) do
                  {:ok, user} -> user
                  {:error, changeset} -> throw changeset
                end

    # insert user in main db
    %{ username: username, id: id } = auth_user
    main_user = MainUser.changeset(
      %MainUser{}, %{
        name: username,
        auth_user_id: id
      }
    )
    main_user = case MainRepo.insert(main_user) do
                  {:ok, user} -> user
                  {:error, changeset} -> throw changeset
                end

    %{
      auth_user: auth_user,
      main_user: main_user
    }
  end


  def login(conn, username, password) do
    # get user
    user = AuthUser |> AuthRepo.get_by(username: username)
    if !user do
      raise ApiServer.Services.Auth.Errors.LoginError
    end

    # compare password
    match = ExBcrypt.match(password, user.password)
    if !match do
      raise ApiServer.Services.Auth.Errors.LoginError
    end
  end

end
