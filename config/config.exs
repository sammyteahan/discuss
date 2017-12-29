# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, Discuss.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GuEpP/RPlgCmW/uh2Se7PsXvh7ta805bi6zNqn83urAPPaZ44YUm33yMDkvxyRzc",
  render_errors: [view: Discuss.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Ueberauth configuration
config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [] }
  ]

# Ueberauth Oauth configuration with github
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "20edc0e6e3b04011446f",
  client_secret: "a74790e86f930808c48e10b654672e81aab723de"
