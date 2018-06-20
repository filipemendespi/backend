use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :re, ReWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("HOST"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  check_origin: false

# Do not print debug messages in production
config :logger, level: :info

config :re, ReWeb.Guardian,
  allowed_algos: ["ES512"],
  secret_key: %{
    "alg" => "ES512",
    "crv" => "P-521",
    "d" => System.get_env("GUARDIAN_D"),
    "kty" => "EC",
    "use" => "sig",
    "x" => System.get_env("GUARDIAN_X"),
    "y" => System.get_env("GUARDIAN_Y")
  }

config :re, Re.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :re, ReWeb.Notifications.Emails.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SEND_GRID_API_KEY")

config :re,
  to: System.get_env("INTEREST_NOTIFICATION_EMAILS"),
  from: System.get_env("ADMIN_EMAIL"),
  frontend_url: System.get_env("FRONTEND_URL"),
  pipedrive_url: System.get_env("PIPEDRIVE_URL"),
  pipedrive_token: System.get_env("PIPEDRIVE_TOKEN"),
  pipedrive_webhook_user: System.get_env("PIPEDRIVE_WEBHOOK_USER"),
  pipedrive_webhook_pass: System.get_env("PIPEDRIVE_WEBHOOK_PASS"),
  env: System.get_env("ENV")

config :re, ReWeb.Search.Cluster,
  url: System.get_env("ELASTICSEARCH_URL"),
  username: System.get_env("ELASTICSEARCH_KEY"),
  password: System.get_env("ELASTICSEARCH_SECRET")
