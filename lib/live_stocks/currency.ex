defmodule LiveStocks.Currency do
  use GenServer

  # Client

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def convert(pid, currency) do
    GenServer.call(pid, {:convert, currency})
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:convert, currency}, _from, state) do
    case state[currency] do
      nil ->
        result = fetch_currency_rates(currency)

        case result do
          {:ok, sek_value} ->
            {:reply, {:ok, sek_value}, Map.put(state, currency, sek_value)}

          {:error, reason} ->
            IO.inspect(reason)
            {:reply, {:error, reason}, state}
        end

      value ->
        {:reply, {:ok, value}, state}
    end
  end

  def fetch_currency_rates(base_currency) do
    api_key = Application.fetch_env!(:live_stocks, :free_currency_api_key)

    url =
      "https://api.freecurrencyapi.com/v1/latest?apikey=#{api_key}&base_currency=#{base_currency}&currencies=SEK"

    IO.inspect("Fetching currency rates for #{base_currency}")
    response = HTTPoison.get(url)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        data =
          Poison.decode!(body)

        {:ok, data["data"]}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
