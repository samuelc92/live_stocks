defmodule LiveStocksWeb.WalletHTML do
  @moduledoc """
  This module contains pages rendered by WalletController.

  See the `wallet_html` directory for all templates available.
  """
  use LiveStocksWeb, :html

  embed_templates "wallet_html/*"

  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end
