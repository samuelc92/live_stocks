defmodule LiveStocks.Repo.Migrations.CreateMarketStockClose do
  use Ecto.Migration

  def change do
    create table(:market_stock_closes) do
      add :stock, :string
      add :close_price, :decimal
      add :currency, :string

      timestamps(type: :utc_datetime)
    end
  end
end
