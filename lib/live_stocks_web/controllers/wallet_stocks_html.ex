defmodule LiveStocksWeb.WalletStocksHTML do
  @moduledoc """
  This module contains pages rendered by WalletStocksController.

  See the `wallet_stocks_html` directory for all templates available.
  """
  use LiveStocksWeb, :html

  embed_templates "wallet_stocks_html/*"

  @doc """
  Renders a wallet stocks form.
  """
  # attr :changeset, Ecto.Changeset, required: true
  # attr :action, :string, required: true

  # def wallet_stocks_form(assigns)
end
