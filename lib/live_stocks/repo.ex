defmodule LiveStocks.Repo do
  use Ecto.Repo,
    otp_app: :live_stocks,
    adapter: Ecto.Adapters.Postgres
end
