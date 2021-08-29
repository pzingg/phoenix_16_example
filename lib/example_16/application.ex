defmodule Example16.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Example16.Repo,
      # Start the Telemetry supervisor
      Example16Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Example16.PubSub},
      # Start the Endpoint (http/https)
      Example16Web.Endpoint
      # Start a worker by calling: Example16.Worker.start_link(arg)
      # {Example16.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Example16.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Example16Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
