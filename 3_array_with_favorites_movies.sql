SELECT 
    u.user_id AS ID,
    u.username AS Username,
    ARRAY_AGG(fm.movie_id) AS favorite_movie_ids
FROM 
    "user" u
LEFT JOIN 
    favorite_movie fm ON u.user_id = fm.user_id
GROUP BY 
    u.user_id, u.username
ORDER BY 
    u.user_id;
