import pandas as pd
import requests
from bs4 import BeautifulSoup

def fetch_sp500_tickers(output_path="data/tickers/sp500_tickers.csv"):
    """Fetch the S&P 500 tickers from Wikipedia and save them to a CSV file."""
    url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
    response = requests.get(url)
    response.raise_for_status()
    
    soup = BeautifulSoup(response.text, "html.parser")
    table = soup.find("table", {"id": "constituents"})
    
    df = pd.read_html(str(table))[0]
    df = df[["Symbol", "Security"]]  # Keep only ticker and company name
    
    df.to_csv(output_path, index=False)
    print(f"Saved S&P 500 tickers to {output_path}")

if __name__ == "__main__":
    fetch_sp500_tickers()
