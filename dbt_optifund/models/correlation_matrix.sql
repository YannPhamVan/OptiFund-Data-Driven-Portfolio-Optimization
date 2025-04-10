-- Get final cumulative return per indice
WITH cumulative_returns AS (
  SELECT
    indice,
    SAFE_DIVIDE(
      MAX(close_filled),
      MIN(close_filled)
    ) - 1 AS cumulative_return
  FROM {{ ref('daily_returns') }}
  GROUP BY indice
),

-- Ranking indices by descending cumulative return
ranked_indices AS (
  SELECT
    indice,
    cumulative_return,
    RANK() OVER (ORDER BY cumulative_return DESC) AS performance_rank
  FROM cumulative_returns
),

-- Base data for correlation
base_data AS (
  SELECT
    r.indice,
    r.performance_rank,
    d.date,
    d.close_filled
  FROM {{ ref('daily_returns') }} d
  JOIN ranked_indices r USING (indice)
),

-- Pairwise returns
paired_returns AS (
  SELECT
    a.indice AS indice_1,
    b.indice AS indice_2,
    a.performance_rank AS rank_1,
    b.performance_rank AS rank_2,
    a.date,
    a.close_filled AS return_1,
    b.close_filled AS return_2
  FROM base_data a
  JOIN base_data b
    ON a.date = b.date
   AND a.indice < b.indice
)

SELECT
  indice_1,
  indice_2,
  rank_1,
  rank_2,
  CORR(return_1, return_2) AS correlation
FROM paired_returns
GROUP BY indice_1, indice_2, rank_1, rank_2
ORDER BY rank_1, rank_2
