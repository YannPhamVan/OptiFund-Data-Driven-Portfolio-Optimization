import yfinance as yf
import pandas as pd
import os
from datetime import datetime

# Define constants
DATA_DIR = "data/raw"
EXCLUDED_TICKERS = {"BRK.B", "BF.B"}  # Ignored tickers due to issues

# Ensure data directory exists
os.makedirs(DATA_DIR, exist_ok=True)

def fetch_sp500_prices():
    """Fetch daily closing prices for S&P 500 stocks and save as Parquet."""
    # Load tickers
    sp500_tickers = pd.read_csv("data/tickers/sp500_tickers.csv")["Symbol"].tolist()
    sp500_tickers = [t for t in sp500_tickers if t not in EXCLUDED_TICKERS]
    
    print(f"Fetching data for {len(sp500_tickers)} tickers...")
    
    # Download data
    data = yf.download(sp500_tickers, period="5y", interval="1d", auto_adjust=True, group_by="ticker")
    
    if data.empty:
        print("No data downloaded.")
        return
    
    # Extract closing prices
    close_prices = data.xs("Close", level=1, axis=1, drop_level=False)
    
    # Save to Parquet
    file_path = os.path.join(DATA_DIR, f"sp500_prices_{datetime.today().strftime('%Y-%m-%d')}.parquet")
    close_prices.to_parquet(file_path, engine="pyarrow")
    
    print(f"Data saved to {file_path}")

if __name__ == "__main__":
    fetch_sp500_prices()
