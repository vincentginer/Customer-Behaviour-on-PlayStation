-- Expected end result -> Number of games sold when the player gets his first trophy 
-- Extracting the first trophy each player got on each games
WITH achievement_acquired AS (
  SELECT 
        player_id, 
        CAST(game_id AS INT64) AS game_id,-- cast the game_id as INT for join later
        achievement_nonunique_id,
       date_acquired
  FROM (
      SELECT player_id,
            SPLIT(achievement_id, '_')[OFFSET(0)] AS game_id, -- Extracting game_id to join later
            SPLIT(achievement_id, '_')[OFFSET(1)] AS achievement_nonunique_id,
            date_acquired,
            ROW_NUMBER() OVER (
                PARTITION BY player_id, SPLIT(achievement_id, '_')[OFFSET(0)] -- Setting 1 only to the first achievement acquired 
                ORDER BY date_acquired ASC
            ) AS rn
      FROM `playstation-project-454010.playstation_data_cleaned.history_cleaned`
  )
  WHERE rn = 1 AND date_acquired > '2013-11-15'
)
-- Join with games_cleaned table to add platform, title and category
SELECT 
    player_id, 
    achievement_acquired.game_id,
    date_acquired, 
    platform,
    title,
    category
FROM achievement_acquired
LEFT JOIN `playstation-project-454010.playstationdata_transformed.games_cleaned_category_added_transformation` 
USING(game_id)
WHERE platform = 'PS4' OR platform = 'PS5'
