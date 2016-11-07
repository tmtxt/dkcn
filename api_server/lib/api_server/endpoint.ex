defmodule ApiServer.Endpoint do
  use Phoenix.Endpoint, otp_app: :api_server

  socket "/socket", ApiServer.UserSocket

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug ApiServer.Router
end
