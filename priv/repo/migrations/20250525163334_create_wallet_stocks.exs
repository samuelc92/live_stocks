defmodule LiveStocks.Repo.Migrations.CreateWalletStocks do
  use Ecto.Migration

  def change do
    create table(:wallet_stocks) do
      add :stock, :string
      add :description, :string
      add :quantity, :integer
      add :wallet_id, references(:wallet, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:wallet_stocks, [:wallet_id])
  end
end
