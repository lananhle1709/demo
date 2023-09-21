defmodule Friends.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FriendsWeb.Telemetry,
      # Start the Ecto repository
      Friends.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Friends.PubSub},
      # Start Finch
      {Finch, name: Friends.Finch},
      # Start the Endpoint (http/https)
      FriendsWeb.Endpoint
      # Start a worker by calling: Friends.Worker.start_link(arg)
      # {Friends.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Friends.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FriendsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
