-- The goal is to find who are the developers that are selling the most. We remove the free games, not corresponding to the strategy.

WITH devs_actual AS (
  SELECT  
    game_id,
    platform,
    developers,
    category,
  FROM `playstation-project-454010.playstationdata_transformed.games_cleaned_category_added_transformation` 
  WHERE release_date > '2013-11-15' AND (platform = 'PS4' OR platform = 'PS5') -- Date range from launch of PS4, and excluding remaining of PS3 / PSVita
),
-- Joining to get the price at which the game was sold
 price_per_game AS (
  SELECT
    *
  FROM devs_actual 
  LEFT JOIN `playstation_data_cleaned.prices_cleaned` as p_c 
  USING(game_id)
),
-- Counting how many people bought each games
  games_sold AS (
SELECT 
  game_id,
  COUNT(*) AS number_sold -- Counting rows
FROM `playstation-project-454010.playstation_data_cleaned.purchased_games_cleaned`
GROUP BY game_id
)
-- Join games_sold and price per game to get the revenue per devs
SELECT 
  game_id,
  CASE
    WHEN developers IN ('Capcom','Capcom Entertainment','CAPCOM Co. Ltd.','CAPCOM Co.') THEN 'Capcom'
    WHEN developers IN ('rockstar north','Rockstar Games') THEN 'Rockstar Games'
    WHEN developers IN ('DICE','Dice') THEN 'Dice'
    WHEN developers IN ('Ubisoft','Ubisoft Montreal','Ubisoft Paris','Ubisoft Quebec') THEN 'Ubisoft'
    ELSE developers
  END AS developers,
  category,
  platform,
  usd AS unit_price,
  games_sold.number_sold,
  ROUND((usd * games_sold.number_sold),2) AS total_revenue 
FROM price_per_game
LEFT JOIN games_sold 
USING(game_id)
WHERE games_sold.number_sold IS NOT NULL AND ROUND((usd * games_sold.number_sold),2) IS NOT NULL AND ROUND((usd * games_sold.number_sold),2) !=0