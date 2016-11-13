defmodule ApiServer.Services.Auth do

  alias ApiServer.MainRepo
  alias ApiServer.AuthRepo
  alias ApiServer.RedisPool
  alias ApiServer.Models.Main.User, as: MainUser
  alias ApiServer.Models.Auth.User, as: AuthUser
  import Ecto.Query

  @typedoc """
  Context data type for logging
  """
  @type context :: %{log_trace: map}

  @typedoc """
  The return data after login
  """
  @type login_data :: %{
    username: String.t,
    user_role: String.t,
    auth_token: String.t,
    expired_at: number
  }


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


  @doc """
  Login with username and password, generate the auth token and write to redis
  """
  @spec login(context, String.t, String.t) :: login_data
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

    # generate auth token (username + uuid)
    %AuthUser{
      user_role: user_role, username: username
    } = user
    token = "#{user.username}-#{UUID.uuid4()}"

    # write to redis, set expire time 1 week later
    second_for_one_week = 604800
    now = DateTime.to_unix(DateTime.utc_now())
    expired_at = now + second_for_one_week
    redis_key = "auth:#{user.username}"

    # write to redis
    res = case RedisPool.pipeline([
                ~w(HMSET #{redis_key} username #{username} userrole #{user_role} token #{token}),
                ~w(EXPIREAT #{redis_key} #{expired_at}),
                ~w(HGETALL #{redis_key})
              ]) do
            {:ok, res} -> res
            {:error, error} -> raise ApiServer.Services.Auth.Errors.LoginError
          end
    %{
      username: username,
      user_role: user_role,
      auth_token: token,
      expired_at: expired_at * 1000
    }
  end

end
