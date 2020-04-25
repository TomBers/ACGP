defmodule Acgp.Repo do
  use Ecto.Repo,
    otp_app: :acgp,
    adapter: Ecto.Adapters.Postgres
end
