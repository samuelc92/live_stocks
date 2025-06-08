defmodule LiveStocks.WalletStocks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallet_stocks" do
    field :description, :string
    field :stock, :string
    field :quantity, :integer

    belongs_to :wallet, LiveStocks.Wallet

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wallet_stocks, attrs) do
    wallet_stocks
    |> cast(attrs, [:stock, :description, :quantity, :wallet_id])
    |> validate_required([:stock, :description, :quantity, :wallet_id])
  end
end
