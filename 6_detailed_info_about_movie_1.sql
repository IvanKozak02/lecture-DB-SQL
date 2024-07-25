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
        'Last name', p.last_name,
        'Photo', (SELECT row_to_json(fp.*)
                  FROM file fp
                  INNER JOIN person_file pf ON fp.file_id = pf.file_id
                  WHERE pf.person_id = p.person_id AND pf.is_primary = TRUE)
    ) AS Director,
    json_agg(
        json_build_object(
            'ID', a.actor_id,
            'First name', ap.first_name,
            'Last name', ap.last_name,
            'Photo', (SELECT row_to_json(af.*)
                      FROM file af
                      INNER JOIN person_file apf ON af.file_id = apf.file_id
                      WHERE apf.person_id = ap.person_id AND apf.is_primary = TRUE)
        )
    ) AS Actors,
    json_agg(
        json_build_object(
            'ID', g.genre_id,
            'Name', g.genre_name
        )
    ) AS Genres
FROM 
    movie m
INNER JOIN 
    file f ON m.poster_id = f.file_id
INNER JOIN 
    person p ON m.director_id = p.person_id
LEFT JOIN 
    character c ON c.movie_id = m.movie_id
LEFT JOIN 
    actor a ON c.actor_id = a.actor_id
LEFT JOIN 
    person ap ON a.person_id = ap.person_id
LEFT JOIN 
    movie_genre mg ON m.movie_id = mg.movie_id
LEFT JOIN 
    genre g ON mg.genre_id = g.genre_id
WHERE 
    m.movie_id = 1
GROUP BY 
    m.movie_id, m.title, m.release_date, m.duration, m.description, f.file_id, p.person_id
ORDER BY 
    m.release_date DESC;