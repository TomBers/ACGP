defmodule Acgp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Acgp.Repo,
      # Start the Telemetry supervisor
      AcgpWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Acgp.PubSub},
      # Start the Endpoint (http/https)
      AcgpWeb.Endpoint,
      AcgpWeb.Presence
      # Start a worker by calling: Acgp.Worker.start_link(arg)
      # {Acgp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acgp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AcgpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
