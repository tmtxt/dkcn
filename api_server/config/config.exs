# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api_server,
  ecto_repos: [ApiServer.MainRepo]

# Configures the endpoint
config :api_server, ApiServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2jC+jfWjfSBCKN9i/RdSaHLV7sPSJAgmmuCBDXNPWydU2GTnsRwFuUrPhbftf2tX",
  render_errors: [view: ApiServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ApiServer.PubSub,
           adapter: Phoenix.PubSub.PG2],
  http: [port: 4000],
  debug_errors: false,
  check_origin: false,
  watchers: [],

  # code reloading
  code_reloader: System.get_env("API_SERVER_CODE_RELOADER") == "true",
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure your database
config :api_server, ApiServer.MainRepo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_MAIN_USER"),
  database: System.get_env("POSTGRES_MAIN_DATABASE"),
  hostname: System.get_env("POSTGRES_MAIN_SERVER"),
  port: System.get_env("POSTGRES_MAIN_PORT"),
  pool_size: 10

config :api_server, ApiServer.AuthRepo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_AUTH_USER"),
  database: System.get_env("POSTGRES_AUTH_DATABASE"),
  hostname: System.get_env("POSTGRES_AUTH_SERVER"),
  port: System.get_env("POSTGRES_AUTH_PORT"),
  pool_size: 10

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, String.to_integer(System.get_env("API_SERVER_STACKTRACE_DEPTH"))
