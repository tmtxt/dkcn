defmodule ApiServer.Services.Auth.Errors do
  defmodule LoginError do
    @moduledoc """
    Exception raised when login fail
    """

    defexception message: "Username or password not match", plug_status: 401
  end

end
