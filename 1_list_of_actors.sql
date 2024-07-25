SELECT 
    a.actor_id AS ID,
    COALESCE(p.first_name, ua.first_name) AS first_name,
    COALESCE(p.last_name, ua.last_name) AS last_name,
    SUM(m.budget) AS total_movies_budget
FROM 
    actor a
LEFT JOIN 
    person p ON a.person_id = p.person_id
LEFT JOIN 
    unknown_actor ua ON a.unknown_actor_id = ua.unknown_actor_id
INNER JOIN 
    character c ON a.actor_id = c.actor_id
INNER JOIN 
    movie m ON c.movie_id = m.movie_id
GROUP BY 
    a.actor_id, p.first_name, p.last_name, ua.first_name, ua.last_name
ORDER BY 
    total_movies_budget DESC;
