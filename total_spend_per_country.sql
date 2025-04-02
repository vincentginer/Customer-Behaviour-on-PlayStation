WITH table AS ( 
  SELECT
    player_id,
    country,
    SUM(usd) AS usd
  FROM `playstation_data_cleaned.purchased_games_cleaned`
  JOIN `playstation_data_cleaned.players_cleaned` USING (player_id)
  JOIN `playstation_data_cleaned.prices_cleaned` USING (game_id)
  GROUP BY player_id, country
)

SELECT
  country,
  ROUND(SUM(usd), 2) AS total_money_spent,
  ROUND(AVG(usd), 2) AS avg_spent_per_player
FROM table
GROUP BY country
ORDER BY total_money_spent DESC;