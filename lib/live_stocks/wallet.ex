defmodule LiveStocks.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallet" do
    field :balance, :decimal

    has_many :stocks, LiveStocks.WalletStocks

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end
