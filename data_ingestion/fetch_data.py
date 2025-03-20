import yfinance as yf
import pandas as pd

def fetch_stock_data(tickers, start_date, end_date):
    """Fetches historical stock data from yfinance."""
    data = yf.download(tickers, start=start_date, end=end_date)
    return data

if __name__ == "__main__":
    # Example usage
    tickers = ["AAPL", "GOOGL", "MSFT"]
    df = fetch_stock_data(tickers, "2023-01-01", "2023-12-31")
    print(df.head())