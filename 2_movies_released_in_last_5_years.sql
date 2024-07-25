SELECT 
    m.movie_id AS ID,
    m.title AS Title,
    COUNT(DISTINCT a.actor_id) AS actors_count
FROM 
    movie m
INNER JOIN 
    character c ON m.movie_id = c.movie_id
INNER JOIN 
    actor a ON c.actor_id = a.actor_id
WHERE 
    m.release_date >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY 
    m.movie_id, m.title
ORDER BY 
    actors_count DESC;