defmodule ApiServer.MainRepo do
  use Ecto.Repo, otp_app: :api_server
end

defmodule ApiServer.AuthRepo do
  use Ecto.Repo, otp_app: :api_server
end
