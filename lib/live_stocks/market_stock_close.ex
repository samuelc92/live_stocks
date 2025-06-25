defmodule LiveStocks.MarketStockClose do
  use Ecto.Schema
  import Ecto.Changeset

  schema "market_stock_closes" do
    field :stock, :string
    field :close_price, :decimal
    field :currency, :string
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(market_stock_close, attrs) do
    market_stock_close
    |> cast(attrs, [:stock, :close, :currency])
    |> validate_required([:stock, :close, :currency])
  end
end
