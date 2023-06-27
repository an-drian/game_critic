defmodule GameCritic.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GameCritic.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GameCritic.PubSub},
      # Start Finch
      {Finch, name: GameCritic.Finch}
      # Start a worker by calling: GameCritic.Worker.start_link(arg)
      # {GameCritic.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GameCritic.Supervisor)
  end
end
