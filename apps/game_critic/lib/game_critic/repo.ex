defmodule GameCritic.Repo do
  use Ecto.Repo,
    otp_app: :game_critic,
    adapter: Ecto.Adapters.Postgres
end
