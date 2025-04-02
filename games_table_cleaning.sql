-- 1. Checking for primary Key
SELECT 
  gameid,
  COUNT(*) as nb
FROM `playstation-project-454010.playstation_data.games` 
GROUP BY gameid
HAVING nb >1;

-- Which game have multiple entries? 5341
SELECT
  title,
  platform,
  COUNT(*) as nb
FROM `playstation-project-454010.playstation_data.games` 
GROUP BY title, platform
HAVING nb >1;

-- Retriving the games with multiple gameid: 17340 entries
WITH duplicated_titles AS (
  SELECT
    title
  FROM
    `playstation-project-454010.playstation_data.games`
  GROUP BY
    title
  HAVING
    COUNT(*) > 1
)
SELECT
  t.title,
  t.gameid,
  t.platform
FROM
  `playstation-project-454010.playstation_data.games` t
JOIN
  duplicated_titles dt
ON
  t.title = dt.title
ORDER BY title;


-- Games with multiple release date: most of them are on # consoles
SELECT
  title,
  COUNT(DISTINCT release_date) AS release_date_count
FROM
  `playstation-project-454010.playstation_data.games`
GROUP BY
  title
HAVING
  COUNT(DISTINCT release_date) > 1;

-- 2. Checking for NULL values
-- Gameid column: None
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE gameid IS NULL;

-- Title column: None
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE title IS NULL;

-- platform column: None nulls
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE platform IS NULL;

-- Developpers column: 17 nulls
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE developers IS NULL;

-- Publishers column: - > 11 nulls
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE publishers IS NULL;

-- Genre column: -> 142 nulls
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE genres IS NULL;

-- Supported Languages: 12537 nulls (means only english) 
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE supported_languages IS NULL;

-- Release date column: None
SELECT COUNT(*) AS null_count
FROM `playstation-project-454010.playstation_data.games`
WHERE release_date IS NULL;

/*3. Transformation: 
Renaming the gameid as game_id
Removing the [''] around the developers and publishers columns.
In genres column:
Lowering the genres column, to avoid multiple occurences of the same genre with LOWER statement 
IF: stating an IF in case there is nothing to return
JSON_EXTRACT_ARRAY: This function extracts an array from a JSON string. It's used to convert the JSON string in the genres column into an array.
JSON_EXTRACT_SCALAR(columns, format of the cell, in this case: '[X]' -> X represent the location of the string in the array): This function extracts a scalar value from a JSON string and returns it as a string without the surrounding quotes.*/


