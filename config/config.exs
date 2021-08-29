# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :example_16,
  ecto_repos: [Example16.Repo],
  generators: [
    binary_id: true, sample_binary_id: "01BADBEEFBADBEEFBADBEEFBAD"
  ]

# Configures database migration defaults
config :example_16, Example16.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :example_16, Example16Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5PdLKC+gWP9W+PmmSk9WPIxdnWLf8tViZy1lfcSM9cATZrsNOI9thDKtyBcl2bPk",
  render_errors: [view: Example16Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Example16.PubSub,
  live_view: [signing_salt: "y1lLDZk8"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :example_16, Example16.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
