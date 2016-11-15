defmodule ApiServer.Test.Services.Auth.CreateUserTest do
  use ApiServer.ConnCase
  alias ApiServer.Services.Auth, as: AuthService
  alias ApiServer.Models.Auth.User, as: AuthUser
  alias ApiServer.Models.Main.User, as: MainUser


  setup do
    on_exit fn ->
      AuthRepo.delete_all(AuthUser)
      MainRepo.delete_all(MainUser)
    end
  end

  test "Missing data - Throw changeset" do
    conn = build_conn()
    user_data = %{
      username: "admin",
      password: "admin"
    }
    error = %Ecto.Changeset{} = catch_throw(AuthService.create_both_user(conn, user_data))
    assert Keyword.has_key?(error.errors, :email)
  end


  test "Create user" do
    conn = build_conn()
    user_data = %{
      email: "me@truongtx.me",
      username: "admin",
      password: "admin",
      user_role: "admin"
    }
    result = AuthService.create_both_user(conn, user_data)
    %{
      auth_user: auth_user,
      main_user: main_user
    } = result
  end
end
