# Joining purchased_games with prices to know which games were bought 
WITH player_spend AS (
  SELECT
    pg_cleaned.player_id AS player_id,
    pg_cleaned.game_id AS game_id,
    p_cleaned.usd AS usd
  FROM `playstation-project-454010.playstation_data_cleaned.purchased_games_cleaned` as pg_cleaned
  LEFT JOIN `playstation-project-454010.playstation_data_cleaned.prices_cleaned` as p_cleaned
  USING(game_id)
)
SELECT
  release_date,
  ROUND(AVG(player_spend.usd),2) AS avg_revenue
FROM `playstation-project-454010.playstation_data_cleaned.games_cleaned`
JOIN player_spend
USING(game_id)
GROUP BY release_date
ORDER BY release_date
