SELECT 
    *,
    CASE
        -- Action & Combat Games
        WHEN LOWER(genre_1) IN ('action', 'action-adventure', 'action horror', 'action-rpg', 'hack & slash', 
                            'beat \'em up', 'shooter', 'first person shooter', 'third person shooter', 
                            'shoot \'em up', 'run & gun', 'vehicular combat', 'gore', 'violent', 'roguelite', 'adventure', 'arcade') THEN 'Action & Combat Games'

        -- Role-Playing Games (RPGs)
        WHEN LOWER(genre_1) IN ('role playing', 'rpg', 'role-playing games (rpg)', 
                            'dungeon crawler', 'metroidvania', 'turn based', 'turn-based') THEN 'Role-Playing Games (RPGs)'

        -- Strategy & Tactical Games
        WHEN LOWER(genre_1) IN ('strategy', 'tower defence', 
                            'management', 'moba', 'multi-player online battle arena', 'platformer') THEN 'Strategy & Tactical Games'

        -- Simulation & Management Games
        WHEN LOWER(genre_1) IN ('simulation', 'management', 'open world', 'sandbox', 
                            'survival', 'survival horror', 'naval', 
                            'automobile', 'aerial', 'simulation racing',
                            'fishing', 'hunting', 'visual novel') THEN 'Simulation & Management Games'

        -- Sports & Racing Games
        WHEN LOWER(genre_1) IN ('sports', 'volleyball', 
                            'racing', 'arcade racing') THEN 'Sports & Racing Games'

        -- Casual, Party & Social Games
        WHEN LOWER(genre_1) IN ('casual', 'party!', 
                            'party', 'social', 
                            'family', 'free to play', 'casino', 
                            'pinball', 'on rails', 'kinect') THEN 'Casual, Party & Social Games'

        -- Puzzle, Trivia & Educational Games
        WHEN LOWER(genre_1) IN ('puzzle', 
                            '? quiz ?', 
                            'educational & trivia',
                            'educational', 'point & click') THEN 'Puzzle, Trivia & Educational Games'

        -- Creative, Collection & Niche Genres
        WHEN LOWER(genre_1) IN ('collection', 'game preview', 
                            'classics', 'indie', 'massively multiplayer', 
                            'battle royale', 'collectable card game', 
                            'card & board', 'board games', 'mech') THEN 'Creative, Collection & Niche Genres'

        -- Music, Rhythm & Dance Games
        WHEN LOWER(genre_1) IN ('music+', 'music/rhythm', 
                            'music & rhythm', 'dance') THEN 'Music, Rhythm & Dance Games'

        -- Horror, Gore & Mature Themes
        WHEN LOWER(genre_1) IN ('horror', 'survival horror', 
                            'gore', 'violent', 'sexual content', 
                            'stealth', 'fighting') THEN 'Horror, Gore & Mature Themes'

        -- Default case
        ELSE 'Other'
    END AS category
FROM `playstation_data_cleaned.games_cleaned`;