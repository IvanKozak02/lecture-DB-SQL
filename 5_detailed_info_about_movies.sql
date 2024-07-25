-- CHANGED CONDITION TO FIT FAKE DATA

SELECT 
    m.movie_id AS ID,
    m.title AS Title,
    m.release_date AS "Release date",
    m.duration AS Duration,
    m.description AS Description,
    row_to_json(f.*) AS Poster,
    json_build_object(
        'ID', p.person_id,
        'First name', p.first_name,
        'Last name', p.last_name
    ) AS Director
FROM 
    movie m
INNER JOIN 
    file f ON m.poster_id = f.file_id
INNER JOIN 
    person p ON m.director_id = p.person_id
INNER JOIN 
    movie_genre mg ON m.movie_id = mg.movie_id
INNER JOIN 
    genre g ON mg.genre_id = g.genre_id
WHERE 
    m.country_iso_code = 'US' AND
    m.release_date >= '2019-01-01' AND
    m.duration > 120 AND
    (g.genre_name = 'Thriller' OR g.genre_name = 'Drama')
GROUP BY 
    m.movie_id, m.title, m.release_date, m.duration, m.description, f.file_id, p.person_id
ORDER BY 
    m.release_date DESC;

