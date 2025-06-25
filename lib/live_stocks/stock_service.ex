defmodule LiveStocks.StockService do
  alias LiveStocks.MarketStockClose
  alias LiveStocks.MarketStackClient
  alias LiveStocks.Currency
  alias LiveStocks.Repo

  def build_balance_data(pid, stock, stock_qty) do
    stock_close = Repo.get_by(MarketStockClose, [stock: stock], prefix: "public")
    IO.inspect("Stock close #{stock_close}")

    with {:ok, stock_close} <- get_balance_data(stock, stock_close),
         {total_stock_value} <- get_total_stock_value_sek(pid, stock, stock_close, stock_qty) do
      Repo.insert_or_update!(stock_close)
      total_stock_value
    else
      _ ->
        IO.inspect("Error on fetching stock data")
        %{total_stock_value: 0}
    end
  end

  def get_balance_data(stock, request) do
    case request do
      {:ok, stock_close} ->
        if DateTime.to_date(stock_close.updated_at) == DateTime.to_date(DateTime.utc_now()) do
          {:ok, stock_close}
        else
          get_latest_stock_data(stock)
        end

      _ ->
        get_latest_stock_data(stock)
    end
  end

  defp get_latest_stock_data(stock) do
    case MarketStackClient.fetch_latest_stock_data(stock) do
      {:ok, data} ->
        {:ok, %{:stock => stock, :close_price => data.close, :currency => data.price_currency}}

      {:error, reason} ->
        # Handle the error
        IO.inspect(reason)
        {:error, reason}
    end
  end

  defp get_total_stock_value_sek(pid, stock, stock_close, stock_qty) do
    case Currency.convert(pid, stock_close.currency) do
      {:ok, result} ->
        sek_value =
          Decimal.round(Decimal.from_float(stock_close.close_price * result["SEK"]), 2)

        IO.inspect("#{stock}: #{sek_value}")
        %{total_stock_value: sek_value |> Decimal.mult(stock_qty)}

      {:error, reason} ->
        IO.inspect(reason)
        %{total_stock_value: 0}
    end
  end
end
