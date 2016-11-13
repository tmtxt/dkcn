defmodule ApiServer.Services.Auth do

  alias Plug.Conn
  alias ApiServer.MainRepo
  alias ApiServer.AuthRepo
  alias ApiServer.RedisPool
  alias ApiServer.Services.Auth.Errors, as: AuthErrors
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

  @typedoc """
  The return data for ensure user functions
  """
  @type ensure_user_data :: %{
    username: String.t,
    user_role: String.t
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
      raise AuthErrors.LoginError
    end

    # compare password
    match = ExBcrypt.match(password, user.password)
    if !match do
      raise AuthErrors.LoginError
    end

    # generate auth token (username + uuid)
    %AuthUser{
      user_role: user_role, username: username
    } = user
    token = UUID.uuid4()

    # write to redis, set expire time 1 week later
    second_for_one_week = 604800
    now = DateTime.to_unix(DateTime.utc_now())
    expired_at = now + second_for_one_week
    redis_key = build_token_key token

    # write to redis
    res = case RedisPool.pipeline([
                ~w(HMSET #{redis_key} username #{username} userrole #{user_role}),
                ~w(EXPIREAT #{redis_key} #{expired_at}),
                ~w(HGETALL #{redis_key})
              ]) do
            {:ok, res} -> res
            {:error, error} -> raise AuthErrors.LoginError
          end

    %{
      username: username,
      user_role: user_role,
      auth_token: token,
      expired_at: expired_at * 1000
    }
  end


  @doc """
  Ensure this user is a logged in user
  """
  @spec ensure_logged_in_user(context) :: ensure_user_data
  def ensure_logged_in_user(conn) do
    token = Conn.get_req_header(conn, "dkcn-auth-token")
    token_key = build_token_key token

    # find token from redis
    res = RedisPool.pipeline([
      ~w(HGET #{token_key} username),
      ~w(HGET #{token_key} userrole)
    ])

    res = case res do
            {:ok, res} -> res
            {:error, _} -> raise AuthErrors.UnauthorizedError
          end
    res = case res do
            [nil, _] -> raise AuthErrors.UnauthorizedError
            [_, nil] -> raise AuthErrors.UnauthorizedError
            result -> result
          end

    [username, user_role] = res
    %{
      username: username,
      user_role: user_role
    }
  end


  @doc """
  Ensure this user is an admin user
  """
  @spec ensure_logged_in_user(context) :: ensure_user_data
  def ensure_admin_user(conn) do
    user_data = ensure_logged_in_user(conn)
    %{user_role: user_role} = user_data
    if user_role !== AuthUser.user_role_admin do
      raise AuthErrors.UnauthorizedError
    end

    user_data
  end


  defp build_token_key(token), do: "auth:#{token}"

end
