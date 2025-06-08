defmodule LiveStocksWeb.HomeLive do
  use LiveStocksWeb, :live_view
  alias LiveStocks.WalletService
  alias LiveStocks.MarketStackClient
  alias LiveStocks.Currency

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

    {:ok,
     socket
     |> assign(:data, build_balance_data(pid, "GOOGL", wallet.balance))
     |> assign(:current_pid, pid)}
  end

  def handle_event("refresh", _params, socket) do
    {:noreply, update(socket, :balance, &(&1 + 1))}
  end

  defp build_balance_data(pid, stock, wallet_balance) do
    case MarketStackClient.fetch_latest_stock_data(stock) do
      {:ok, data} ->
        case Currency.convert(pid, "USD") do
          {:ok, result} ->
            sek_value = Decimal.round(Decimal.from_float(data.close * result["SEK"]), 2)
            %{balance: wallet_balance, total_stocks: sek_value}

          {:error, reason} ->
            IO.inspect(reason)
            %{balance: wallet_balance, total_stocks: 0}
        end

      {:error, reason} ->
        # Handle the error
        IO.inspect(reason)
        %{balance: wallet_balance, total_stocks: 0}
    end
  end
end
