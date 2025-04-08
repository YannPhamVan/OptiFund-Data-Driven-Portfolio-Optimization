-- models/cumulative_returns.sql

WITH ranked_returns AS (
  SELECT
    indice,
    date,
    SAFE_DIVIDE(
      LAST_VALUE(close_filled IGNORE NULLS) OVER ticker_window,
      FIRST_VALUE(close_filled IGNORE NULLS) OVER ticker_window
    ) - 1 AS cumulative_return,
    ROW_NUMBER() OVER (PARTITION BY indice ORDER BY date DESC) AS rn
  FROM {{ ref('daily_returns') }}
  WINDOW ticker_window AS (
    PARTITION BY indice
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  )
)

SELECT
  indice,
  cumulative_return
FROM ranked_returns
WHERE rn = 1
