-- models/cumulative_returns.sql

-- Calculates the total return (in %) for each index between 2016-12-19 and the most recent available date.
-- Missing values are backfilled using the last known value (forward fill).

WITH unpivoted AS (
  SELECT
    date,
    index,
    close
  FROM {{ source('project_dataset', 'indices_data') }}
  UNPIVOT (close FOR index IN (
    China_Shanghai_Composite AS 'China_Shanghai_Composite',
    AEX_Index AS 'AEX_Index',
    All_Ordinaries_Australia AS 'All_Ordinaries_Australia',
    `S&P_ASX_200` AS 'S&P_ASX_200',
    Bombay_BSE_30 AS 'Bombay_BSE_30',
    Bovespa_Index_Bresil AS 'Bovespa_Index_Bresil',
    Cac_Next20 AS 'Cac_Next20',
    Dow_Jones_Industrial_Average AS 'Dow_Jones_Industrial_Average',
    Dow_Jones_Transportation_Average AS 'Dow_Jones_Transportation_Average',
    Dow_Jones_Utility_Average AS 'Dow_Jones_Utility_Average',
    CAC_40 AS 'CAC_40',
    FTSE_100 AS 'FTSE_100',
    DAX_P AS 'DAX_P',
    `S&P_500` AS 'S&P_500',
    HANG_SENG_INDEX AS 'HANG_SENG_INDEX',
    IBEX AS 'IBEX',
    Nasdaq_Composite AS 'Nasdaq_Composite',
    Euronext_100 AS 'Euronext_100',
    Next_150 AS 'Next_150',
    Nikkei_225 AS 'Nikkei_225',
    Nasdaq_Biotechnology AS 'Nasdaq_Biotechnology',
    Nasdaq_100 AS 'Nasdaq_100',
    `S&P_NZX_50_INDEX_GROSS` AS 'S&P_NZX_50_INDEX_GROSS',
    `S&P_100` AS 'S&P_100',
    OMX_Copenhagen_25_Index AS 'OMX_Copenhagen_25_Index',
    Oslo_Bors_All_Share_Index_GI AS 'Oslo_Bors_All_Share_Index_GI',
    Russell_2000_Index AS 'Russell_2000_Index',
    Semiconductor_Sector AS 'Semiconductor_Sector',
    `S&P_500_Equal_Weighted` AS 'S&P_500_Equal_Weighted',
    STI_Index AS 'STI_Index',
    Europe_Stoxx_600 AS 'Europe_Stoxx_600',
    Euro_Stoxx_50 AS 'Euro_Stoxx_50',
    Wilshire_5000_Total_Market AS 'Wilshire_5000_Total_Market'
  ))
),
filled_data AS (
  SELECT
    date,
    index,
    LAST_VALUE(close IGNORE NULLS) OVER (
      PARTITION BY index
      ORDER BY date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS close_filled
  FROM unpivoted
  WHERE date >= '2016-12-19'
),
first_last_close AS (
  SELECT
    index,
    MIN_BY(close_filled, date) AS first_close,
    MAX_BY(close_filled, date) AS last_close
  FROM filled_data
  GROUP BY index
)

SELECT
  index,
  ROUND((last_close - first_close) / first_close * 100, 2) AS return_percent
FROM first_last_close
ORDER BY return_percent DESC
