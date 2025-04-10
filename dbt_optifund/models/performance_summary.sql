-- models/performance_summary.sql

WITH daily_returns_fixed AS (
  SELECT
    indice,
    SAFE_CAST(Date AS DATE) AS date,
    daily_return,
    close_filled
  FROM {{ ref('daily_returns') }}
),

returns_stats AS (
  SELECT
    indice,
    COUNT(*) AS nb_days,
    SUM(daily_return) AS sum_returns,
    AVG(daily_return) AS avg_return,
    STDDEV(daily_return) AS std_return
  FROM daily_returns_fixed
  GROUP BY indice
),

cumulative_returns AS (
  SELECT
    indice,
    SAFE_DIVIDE(
      LAST_VALUE(close_filled IGNORE NULLS) OVER ticker_window,
      FIRST_VALUE(close_filled IGNORE NULLS) OVER ticker_window
    ) - 1 AS cumulative_return,
    ROW_NUMBER() OVER (PARTITION BY indice ORDER BY date DESC) AS rn
  FROM daily_returns_fixed
  WINDOW ticker_window AS (
    PARTITION BY indice
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  )
),

latest_cumulative_returns AS (
  SELECT
    indice,
    cumulative_return
  FROM cumulative_returns
  WHERE rn = 1
)

SELECT
  r.indice,
  r.nb_days,
  r.sum_returns,
  r.avg_return,
  r.std_return,
  l.cumulative_return
FROM returns_stats r
JOIN latest_cumulative_returns l
  ON r.indice = l.indice
ORDER BY cumulative_return DESC
