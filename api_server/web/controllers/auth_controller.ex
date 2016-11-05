defmodule ApiServer.AuthController do
  use ApiServer.Web, :controller

  def get_user(conn, _params) do
    json conn, %{id: "hello"}
  end
end
