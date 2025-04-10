{{ config(
    materialized='table'
) }}

WITH long_format AS (
  -- Unpivoting the 33 indices into (Date, indice, close_value) format
  SELECT Date, 'China_Shanghai_Composite' AS indice, China_Shanghai_Composite AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'AEX_Index' AS indice, AEX_Index AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'All_Ordinaries_Australia' AS indice, All_Ordinaries_Australia AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'S&P_ASX_200' AS indice, `S&P_ASX_200` AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Bombay_BSE_30' AS indice, Bombay_BSE_30 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Bovespa_Index_Bresil' AS indice, Bovespa_Index_Bresil AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Cac_Next20' AS indice, Cac_Next20 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Dow_Jones_Industrial_Average' AS indice, Dow_Jones_Industrial_Average AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Dow_Jones_Transportation_Average' AS indice, Dow_Jones_Transportation_Average AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Dow_Jones_Utility_Average' AS indice, Dow_Jones_Utility_Average AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'CAC_40' AS indice, CAC_40 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'FTSE_100' AS indice, FTSE_100 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'DAX_P' AS indice, DAX_P AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'S&P_500' AS indice, `S&P_500` AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'HANG_SENG_INDEX' AS indice, HANG_SENG_INDEX AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'IBEX' AS indice, IBEX AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Nasdaq_Composite' AS indice, Nasdaq_Composite AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Euronext_100' AS indice, Euronext_100 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Next_150' AS indice, Next_150 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Nikkei_225' AS indice, Nikkei_225 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Nasdaq_Biotechnology' AS indice, Nasdaq_Biotechnology AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Nasdaq_100' AS indice, Nasdaq_100 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'S&P_NZX_50_INDEX_GROSS' AS indice, `S&P_NZX_50_INDEX_GROSS` AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'S&P_100' AS indice, `S&P_100` AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'OMX_Copenhagen_25_Index' AS indice, OMX_Copenhagen_25_Index AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Oslo_Bors_All_Share_Index_GI' AS indice, Oslo_Bors_All_Share_Index_GI AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Russell_2000_Index' AS indice, Russell_2000_Index AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Semiconductor_Sector' AS indice, Semiconductor_Sector AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'S&P_500_Equal_Weighted' AS indice, `S&P_500_Equal_Weighted` AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'STI_Index' AS indice, STI_Index AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Europe_Stoxx_600' AS indice, Europe_Stoxx_600 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Euro_Stoxx_50' AS indice, Euro_Stoxx_50 AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data` UNION ALL
  SELECT Date, 'Wilshire_5000_Total_Market' AS indice, Wilshire_5000_Total_Market AS close_value FROM `dtc-de-project-454412.project_dataset.indices_data`
),

filled_returns AS (
  SELECT
    Date,
    indice,
    LAST_VALUE(close_value IGNORE NULLS) OVER (
      PARTITION BY indice ORDER BY Date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS close_filled
  FROM long_format
),

daily_returns AS (
  SELECT
    Date,
    indice,
    close_filled,
    ROUND(
      SAFE_DIVIDE(
        close_filled - LAG(close_filled) OVER (PARTITION BY indice ORDER BY Date),
        LAG(close_filled) OVER (PARTITION BY indice ORDER BY Date)
      ),
      6
    ) AS daily_return
  FROM filled_returns
)

SELECT * FROM daily_returns
ORDER BY indice, Date
