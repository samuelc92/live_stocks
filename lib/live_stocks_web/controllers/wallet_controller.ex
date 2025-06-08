defmodule LiveStocksWeb.WalletController do
  use LiveStocksWeb, :controller
  alias LiveStocks.WalletService

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    changeset = LiveStocks.Wallet.changeset(%LiveStocks.Wallet{}, %{balance: 0.0})
    render(conn, :index, changeset: changeset, wallet: %LiveStocks.Wallet{})
  end

  def show(conn, %{"id" => id}) do
    wallet =
      id
      |> WalletService.get_wallet!()

    changeset = WalletService.change_wallet(wallet)
    render(conn, :index, changeset: changeset, wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = WalletService.get_wallet!(id)

    case WalletService.update_wallet(wallet, wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet updated successfully.")
        |> redirect(to: ~p"/wallet/#{wallet}")

      {:error, changeset} ->
        render(conn, :index, changeset: changeset, wallet: wallet)
    end
  end
end
