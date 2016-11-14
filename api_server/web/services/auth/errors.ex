defmodule ApiServer.Services.Auth.Errors do

  defmodule LoginError do
    @moduledoc """
    Exception raised when login fail
    """
    defexception message: "Username or password not match", plug_status: 401
  end


  defmodule UnauthorizedError do
    @moduledoc """
    Exception raised when user's not authorized for this action
    """
    defexception message: "Not authorized", plug_status: 403
  end


  defmodule NotLoggedInError do
    @moduledoc """
    Exception raised when user's not authorized for this action
    """
    defexception message: "Not login", plug_status: 401
  end
end
