defmodule LiveStocks.Repo.Migrations.CreateWallet do
  use Ecto.Migration

  def change do
    create table(:wallet) do
      add :balance, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
