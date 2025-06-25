defmodule LiveStocksWeb.HomeLive do
  use LiveStocksWeb, :live_view
  alias LiveStocks.WalletService
  alias LiveStocks.MarketStackClient
  alias LiveStocks.Currency
  alias LiveStocks.StockService

  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-md p-6 mt-4">
      <div class="grid grid-cols-2 gap-4">
        <div class="p-4 border rounded-lg">
          <h2 class="text-xl font-semibold mb-2">Wallet Balance</h2>
          <p class="text-3xl font-bold text-green-600">{@data.balance} kr</p>
        </div>

        <div class="p-4 border rounded-lg">
          <h2 class="text-xl font-semibold mb-2">Total Stocks</h2>
          <p class="text-3xl font-bold text-blue-600">{@data.total_stocks} kr</p>
        </div>
      </div>

      <div class="flex justify-center mt-6">
        <button
          phx-click="refresh"
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          Refresh Data
        </button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    wallet = WalletService.get_wallet!(1)
    {:ok, pid} = Currency.start_link()

    tasks =
      wallet.stocks
      |> Enum.map(fn stock ->
        Task.async(fn ->
          StockService.build_balance_data(pid, stock.stock, stock.quantity)
        end)
      end)

    stock_results = Task.await_many(tasks, 10_000)

    total_stocks_value =
      stock_results
      |> Enum.reduce(Decimal.new(0), fn x, acc -> Decimal.add(x.total_stock_value, acc) end)

    {:ok,
     socket
     |> assign(:data, %{balance: wallet.balance, total_stocks: total_stocks_value})
     |> assign(:current_pid, pid)}
  end

  def handle_event("refresh", _params, socket) do
    {:noreply, update(socket, :balance, &(&1 + 1))}
  end

  # TODO: Delete
  defp build_balance_data(pid, stock, stock_qty) do
    case MarketStackClient.fetch_latest_stock_data(stock) do
      {:ok, data} ->
        case Currency.convert(pid, data.price_currency) do
          {:ok, result} ->
            sek_value =
              Decimal.round(Decimal.from_float(data.close * result["SEK"]), 2)

            IO.inspect("#{stock}: #{sek_value}")
            %{total_stock_value: sek_value |> Decimal.mult(stock_qty)}

          {:error, reason} ->
            IO.inspect(reason)
            %{total_stock_value: 0}
        end

      {:error, reason} ->
        # Handle the error
        IO.inspect(reason)
        %{total_stock_value: 0}
    end
  end
end
