defmodule ApiServer.AuthController do
  use ApiServer.Web, :controller

  alias ApiServer.Services.Auth, as: AuthService
  import ApiServer.EctoUtil, only: [errors_to_map: 1]

  def get_user(conn, _params) do
    json conn, %{id_hello: "hello"}
  end


  @doc """
  Response: see create_both_user function
  """
  def create_user(conn, params) do
    AuthService.ensure_admin_user(conn)
    params = Map.put params, "user_role", "user"
    try do
      res = AuthService.create_both_user conn, params
      json(conn, res)
    catch
      changeset = %Ecto.Changeset{} -> conn
      |> put_status(400)
      |> json(errors_to_map(changeset))
    end
  end


  def login(conn, params) do
    %{"username" => username, "password" => password} = params
    json(conn, AuthService.login(conn, username, password))
  end


  # @doc """
  # Use for initialize
  # This function should be comment out in production. Only enable it in local and point to
  # the db you want to create.
  # Response: see create_both_user function
  # """
  # def create_admin(conn, params) do
  #   params = Map.put params, "user_role", "admin"
  #   try do
  #     res = create_both_user conn, params
  #     json(conn, res)
  #   catch
  #     changeset = %Ecto.Changeset{} -> conn
  #     |> put_status(400)
  #     |> json(errors_to_map(changeset))
  #   end
  # end

end
