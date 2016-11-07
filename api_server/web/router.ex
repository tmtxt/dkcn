defmodule ApiServer.Router do
  use ApiServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Poison
  end

  # Other scopes may use custom stacks.
  scope "/api", ApiServer do
    pipe_through :api

    get "/auth-users", AuthController, :get_user
    post "/auth-users", AuthController, :create_user
  end
end
