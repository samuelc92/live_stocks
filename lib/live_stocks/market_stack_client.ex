defmodule LiveStocks.MarketStackClient do
  defstruct [:close, :volume, :price_currency, :date]

  def fetch_latest_stock_data(symbol) do
    api_key = Application.fetch_env!(:live_stocks, :market_stack_api_key)

    url =
      "http://api.marketstack.com/v2/eod/latest?access_key=#{api_key}&symbols=#{symbol}"

    response = HTTPoison.get(url)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        data =
          Poison.decode!(body, as: %{"data" => [%LiveStocks.MarketStackClient{}]})

        {:ok, hd(data["data"])}

      {:ok, %HTTPoison.Response{status_code: 429}} ->
        IO.inspect("Error: Market stack usage limit")
        {:error, "usage_limit"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
