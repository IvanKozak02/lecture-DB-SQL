SELECT 
    p.person_id AS director_id,
    CONCAT(p.first_name, ' ', p.last_name) AS director_name,
    ROUND(AVG(m.budget),2) AS average_budget
FROM 
    movie m
INNER JOIN 
    person p ON m.director_id = p.person_id
GROUP BY 
    p.person_id, p.first_name, p.last_name
ORDER BY 
    average_budget DESC;
