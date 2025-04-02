WITH price_per_players AS (
  SELECT 
    g_c.player_id,
    g_c.game_id,
    p_c.usd
  FROM `playstation-project-454010.playstation_data_cleaned.purchased_games_cleaned` AS g_c
  LEFT JOIN `playstation-project-454010.playstation_data_cleaned.prices_cleaned` AS p_c
  USING(game_id)
 LEFT JOIN `playstationdata_transformed.games_cleaned_category_added_transformation` AS games
  USING(game_id)
  WHERE games.platform IN ("PS4", "PS5") AND games.release_date > "2013-11-15"
),
  sum_per_player AS (
  SELECT 
    player_id, 
    ROUND(SUM(price_per_players.usd)) AS usd
  FROM price_per_players
  GROUP BY player_id
)
SELECT
  player_id,
  country,
  sum_per_player.usd
FROM `playstation-project-454010.playstation_data_cleaned.players_cleaned`
FULL JOIN sum_per_player
USING(player_id)