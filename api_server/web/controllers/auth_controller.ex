defmodule ApiServer.AuthController do
  use ApiServer.Web, :controller
  alias ApiServer.Models.Main.User, as: MainUser
  alias ApiServer.Models.Auth.User, as: AuthUser
  import ApiServer.EctoUtil, only: [errors_to_map: 1]


  def get_user(conn, _params) do
    json conn, %{id_hello: "hello"}
  end


  @doc """
  Response: see create_both_user function
  """
  def create_user(conn, params) do
    params = Map.put params, "user_role", "user"
    create_both_user conn, params

  end


  @doc """
  Use for initialize
  This function should be comment out in production. Only enable it in local and point to
  the db you want to create.
  Response: see create_both_user function
  """
  def create_admin(conn, params) do
    params = Map.put params, "user_role", "admin"
    IO.inspect params
    create_both_user conn, params
  end


  # create both user in auth db and main db
  # Create new user in the system, both in auth db and main db.
  # On success, response
  # {
  # auth_user: <object> the inserted auth_user,
  # main_user: <object> the inserted main_user
  # }
  # On error, response code 400
  defp create_both_user(conn, params) do
    try do
      # insert user in auth db
      auth_user = AuthUser.changeset(%AuthUser{}, params)
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

      json(
        conn, %{
          auth_user: auth_user,
          main_user: main_user
        }
      )
    catch
      changeset = %Ecto.Changeset{} -> conn
      |> put_status(400)
      |> json(errors_to_map(changeset))
    end
  end

end
