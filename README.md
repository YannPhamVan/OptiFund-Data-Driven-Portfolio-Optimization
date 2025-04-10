# OptiFund: Data-Driven Portfolio Optimization

## 🧠 Project Overview

**OptiFund** is a data engineering project aiming to build an optimized portfolio from the main world indexes.  
Using historical daily data, the pipeline identifies top-performing assets and removes highly correlated ones to maximize diversification and return.

## 🔧 Tech Stack

- **Kestra** for orchestration
- **Google Cloud Platform** (GCS, BigQuery)
- **Terraform** for infrastructure as code
- **dbt** for analytics transformations
- **Looker Studio** for dashboard visualization
- **yfinance** for data ingestion

## 📁 Project Structure

```bash
├── notebooks/              # Testing Data ingestion using yfinance
├── terraform/              # Infrastructure setup on GCP
├── orchestration_kestra/   # Kestra flows for orchestration
├── dbt_optifund/           # dbt transformations and models
└── README.md               # Project documentation
```

## 📊 Key Results

- Correlation matrix of top assets
- Portfolio construction excluding overlapping assets
- Interactive dashboard with filters by return/correlation

## 🚀 Try It

View the dashboard on Looker Studio ([link here](https://lookerstudio.google.com/reporting/3c99e91f-961a-4504-8187-91c88275a8d5))

## 📌 Status

✅ Ingestion
✅ Orchestration
✅ BigQuery pipeline
🟡 Correlation-based selection (enhancing the sort by return)
🟢 Final dashboard in progress
