defmodule LiveStocks.WalletService do
  import Ecto.Query, warn: false
  alias LiveStocks.WalletStocks
  alias LiveStocks.Repo
  alias LiveStocks.Wallet

  def get_wallet!(id) do
    Wallet
    |> Repo.get!(id)
    |> Repo.preload(:stocks)
  end

  def update_wallet(wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
    |> Repo.update()
  end

  def change_wallet(wallet, attrs \\ %{}) do
    Wallet.changeset(wallet, attrs)
  end

  def get_wallet_stock!(id) do
    WalletStocks
    |> Repo.get!(id)
  end

  def update_wallet_stock(wallet_stock, attrs) do
    wallet_stock
    |> WalletStocks.changeset(attrs)
    |> Repo.update()
  end

  def change_wallet_stocks(wallet, attrs \\ %{}) do
    WalletStocks.changeset(wallet, attrs)
  end

  def create_wallet_stock(attrs) do
    %WalletStocks{}
    |> WalletStocks.changeset(attrs)
    |> Repo.insert()
  end
end
