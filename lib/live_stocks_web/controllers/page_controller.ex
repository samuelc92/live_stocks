defmodule LiveStocksWeb.PageController do
  use LiveStocksWeb, :controller
  alias LiveStocks.WalletService

  def home(conn, _params) do
    # Get the first wallet (assuming single wallet for now)
    wallet = WalletService.get_wallet!(1)

    render(conn, :home, wallet: wallet, total_stocks: 100.00)
  end
end
