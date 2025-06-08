defmodule LiveStocksWeb.WalletStocksController do
  use LiveStocksWeb, :controller
  alias LiveStocks.WalletStocks
  alias LiveStocks.WalletService

  def index(conn, %{"wallet_id" => wallet_id}) do
    changeset = WalletService.change_wallet_stocks(%WalletStocks{})
    render(conn, :index, changeset: changeset, wallet_id: wallet_id)
  end

  def show(conn, %{"wallet_id" => wallet_id, "id" => id}) do
    stock =
      id
      |> WalletService.get_wallet_stock!()

    changeset = WalletService.change_wallet_stocks(stock)
    render(conn, :show, changeset: changeset, stock: stock, wallet_id: wallet_id)
  end

  def create(conn, %{"wallet_id" => wallet_id, "wallet_stocks" => stock_params}) do
    case WalletService.create_wallet_stock(Map.put(stock_params, "wallet_id", wallet_id)) do
      {:ok, _wallet_stock} ->
        conn
        |> put_flash(:info, "Stock created successfully.")
        |> redirect(to: ~p"/wallet/#{wallet_id}")

      {:error, changeset} ->
        render(conn, :index, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "wallet_stocks" => stock_params}) do
    wallet_stock = WalletService.get_wallet_stock!(id)

    case WalletService.update_wallet_stock(wallet_stock, stock_params) do
      {:ok, _wallet_stock} ->
        conn
        |> put_flash(:info, "Stock updated successfully.")
        |> redirect(to: ~p"/wallet/#{id}")

      {:error, changeset} ->
        render(conn, :index, changeset: changeset, wallet: wallet_stock)
    end
  end
end
