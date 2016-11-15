defmodule ApiServer.Test.Services.Auth.CreateUserTest do
  use ApiServer.ConnCase
  alias ApiServer.Services.Auth, as: AuthService

  test "Missing data - Throw changeset" do
    conn = build_conn()
    user_data = %{
      username: "admin",
      password: "admin"
    }
    error = %Ecto.Changeset{} = catch_throw(AuthService.create_both_user(conn, user_data))
    assert error.errors == [email: {"can't be blank", []}]
  end
end
