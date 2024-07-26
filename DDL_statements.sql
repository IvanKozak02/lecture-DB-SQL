CREATE TYPE movie_role AS ENUM ('leading', 'supporting', 'background');
CREATE TYPE person_gender AS ENUM ('not known', 'male', 'female', 'not applicable');


CREATE
DATABASE movie


-- FILE TABLE

CREATE TABLE file
(
    file_id    SERIAL PRIMARY KEY,
    file_name  VARCHAR(255) NOT NULL,
    mime_type  VARCHAR(100) NOT NULL,
    file_key   TEXT         NOT NULL,
    file_url   TEXT         NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
)


-- USER TABLE

CREATE TABLE "user"
(
    user_id    SERIAL PRIMARY KEY,
    username   VARCHAR(100),
    first_name VARCHAR(100)        NOT NULL,
    last_name  VARCHAR(100)        NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    password   VARCHAR(255)        NOT NULL,
    avatar_id  INTEGER,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_avatar
        FOREIGN KEY (avatar_id)
            REFERENCES file (file_id)
            ON DELETE SET NULL
)


-- PERSON TABLE


CREATE TABLE person
(
    person_id        SERIAL PRIMARY KEY,
    first_name       VARCHAR(100) NOT NULL,
    last_name        VARCHAR(100) NOT NULL,
    biography        TEXT,
    date_of_birth    DATE,
    gender           person_gender,
    home_country_iso VARCHAR(5),
    created_at       timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at       timestamp DEFAULT CURRENT_TIMESTAMP
)


-- MOVIE TABLE

CREATE TABLE movie
(
    movie_id         SERIAL PRIMARY KEY,
    title            VARCHAR(255) NOT NULL,
    description      TEXT,
    release_date     DATE,
    budget           DECIMAL(15, 2),
    duration         INTEGER,
    poster_id        INTEGER      REFERENCES file (file_id) ON DELETE SET NULL,
    director_id      INTEGER      REFERENCES person (person_id) ON DELETE SET NULL,
    country_iso_code VARCHAR(5)   NOT NULL,
    created_at       timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at       timestamp DEFAULT CURRENT_TIMESTAMP
)

-- GENRE TABLE
CREATE TABLE genre
(
    genre_id   SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
)

-- MOVIE_GENRE TABLE

CREATE TABLE movie_genre
(
    movie_id INTEGER NOT NULL REFERENCES movie (movie_id) ON DELETE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES genre (genre_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, genre_id)
);

-- FAVOURITE_MOVIE TABLE
CREATE TABLE favorite_movie
(
    user_id  INTEGER REFERENCES "user" (user_id) NOT NULL,
    movie_id INTEGER REFERENCES movie (movie_id) NOT NULL,
    PRIMARY KEY (user_id, movie_id)
)


-- UNKNOWN_ACTOR TABLE

CREATE TABLE unknown_actor
(
    unknown_actor_id SERIAL PRIMARY KEY,
    first_name       VARCHAR(100),
    last_name        VARCHAR(100),
    role_description TEXT,
    created_at       timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at       timestamp DEFAULT CURRENT_TIMESTAMP
)

-- ACTOR TABLE

CREATE TABLE actor
(
    actor_id         SERIAL PRIMARY KEY,
    person_id        INTEGER REFERENCES person (person_id) ON DELETE SET NULL,
    unknown_actor_id INTEGER REFERENCES unknown_actor (unknown_actor_id) ON DELETE SET NULL,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CHARACTER TABLE


CREATE TABLE character
(
    character_id   SERIAL PRIMARY KEY,
    character_name VARCHAR(255) NOT NULL,
    description    TEXT,
    role           movie_role,
    actor_id       INTEGER      REFERENCES actor (actor_id) ON DELETE SET NULL,
    movie_id       INTEGER      REFERENCES movie (movie_id) ON DELETE SET NULL,
    created_at     timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at     timestamp DEFAULT CURRENT_TIMESTAMP
)


-- PERSON_FILE TABLE

CREATE TABLE person_file
(
    file_id    INTEGER REFERENCES file (file_id)     NOT NULL,
    person_id  INTEGER REFERENCES person (person_id) NOT NULL,
    is_primary BOOLEAN   DEFAULT FALSE,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (file_id, person_id)
)


-- FAKE DATA
    INSERT INTO file (file_name, mime_type, file_key, file_url)
VALUES 
('poster1.jpg', 'image/jpeg', 'poster1', 'http://example.com/poster1.jpg'),
('poster2.jpg', 'image/jpeg', 'poster2', 'http://example.com/poster2.jpg'),
('avatar1.jpg', 'image/jpeg', 'avatar1', 'http://example.com/avatar1.jpg'),
('avatar2.jpg', 'image/jpeg', 'avatar2', 'http://example.com/avatar2.jpg'),
('avatar3.jpg', 'image/jpeg', 'avatar3', 'http://example.com/avatar3.jpg'),
('avatar4.jpg', 'image/jpeg', 'avatar4', 'http://example.com/avatar4.jpg'),
('avatar5.jpg', 'image/jpeg', 'avatar5', 'http://example.com/avatar5.jpg'),
('poster3.jpg', 'image/jpeg', 'poster3', 'http://example.com/poster3.jpg'),
('poster4.jpg', 'image/jpeg', 'poster4', 'http://example.com/poster4.jpg'),
('poster5.jpg', 'image/jpeg', 'poster5', 'http://example.com/poster5.jpg'),
('primary1.jpg', 'image/jpeg', 'primary1', 'http://example.com/primary1.jpg'),
('primary2.jpg', 'image/jpeg', 'primary2', 'http://example.com/primary2.jpg'),
('primary3.jpg', 'image/jpeg', 'primary3', 'http://example.com/primary3.jpg'),
('primary4.jpg', 'image/jpeg', 'primary4', 'http://example.com/primary4.jpg'),
('primary5.jpg', 'image/jpeg', 'primary5', 'http://example.com/primary5.jpg');

INSERT INTO "user" (username, first_name, last_name, email, password, avatar_id)
VALUES ('jdoe', 'John', 'Doe', 'jdoe@example.com', 'hashed_password1', 3),
       ('asmith', 'Alice', 'Smith', 'asmith@example.com', 'hashed_password2', 4),
       ('bclark', 'Bob', 'Clark', 'bclark@example.com', 'hashed_password3', 6),
       ('mjones', 'Mary', 'Jones', 'mjones@example.com', 'hashed_password4', 7),
       ('tgreen', 'Tom', 'Green', 'tgreen@example.com', 'hashed_password5', 8);



INSERT INTO person (first_name, last_name, biography, date_of_birth, gender, home_country_iso)
VALUES ('Leonardo', 'DiCaprio', 'An acclaimed actor.', '1974-11-11', 'male', 'US'),
       ('Natalie', 'Portman', 'Award-winning actress.', '1981-06-09', 'female', 'IL'),
       ('Matt', 'Damon', 'Known for his action roles.', '1970-10-08', 'male', 'US'),
       ('Scarlett', 'Johansson', 'Versatile actress.', '1984-11-22', 'female', 'US'),
       ('Joaquin', 'Phoenix', 'Intense performer.', '1974-10-28', 'male', 'US');
('Christopher ', 'Nolan', 'A British and American filmmaker.', '1970-07-30', 'male', 'UK')
,
('Lana ', 'Wachowski ', 'American film and television director.', '1965-07-21', 'female', 'US'),
('Darren', 'Aronofsky ', 'An American filmmaker.', '1969-02-12', 'male', 'US'),
('Todd', 'Phillips', 'An American film director, producer, and screenwriter.', '1970-12-20', 'male', 'US'),
('Keanu', 'Reeves', 'A Canadian actor and musician.', '1964-09-02', 'male', 'CAN'),
('Jessica', 'Chastain', 'The founder of the production company Freckle Film.', '1977-03-24', 'female', 'US');



INSERT INTO movie (title, description, release_date, budget, duration, poster_id, director_id, country_iso_code)
VALUES ('Inception', 'A mind-bending thriller.', '2010-07-16', 160000000, 148, 1, 6, 'US'),
       ('The Matrix', 'A groundbreaking sci-fi film.', '1999-03-31', 63000000, 136, 2, 7, 'US'),
       ('Interstellar', 'A space epic about survival.', '2014-11-07', 165000000, 169, 5, 6, 'US'),
       ('Black Swan', 'A psychological thriller.', '2010-12-03', 13000000, 108, 9, 8, 'US'),
       ('Joker', 'A dark take on the iconic villain.', '2019-10-04', 55000000, 122, 10, 9, 'US');

INSERT INTO genre (genre_name)
VALUES ('Action'),
       ('Drama'),
       ('Comedy'),
       ('Sci-Fi'),
       ('Thriller');

INSERT INTO movie_genre (movie_id, genre_id)
VALUES (1, 1),
       (1, 4),
       (2, 1),
       (2, 4),
       (3, 4),
       (4, 2),
       (5, 2),
       (5, 5);

INSERT INTO favorite_movie (user_id, movie_id)
VALUES (1, 1),
       (1, 3),
       (2, 2),
       (3, 4),
       (4, 5);




INSERT
    INTO unknown_actor (first_name, last_name, role_description)
    VALUES
    ('Mog', 'Irg', 'Background actor with no specific role.'), ('Kol', 'Dag', 'Background actor with no specific role.'), ('Log', 'Mag', 'Extra in several scenes.');


INSERT INTO actor (person_id, unknown_actor_id)
VALUES (1, NULL),
       (2, NULL),
       (NULL, 1),
       (NULL, 2),
       (NULL, 3),
       (3, NULL),
       (4, NULL),
       (5, NULL),
       (10, NULL),
       (11, NULL);

SELECT *
FROM movie
SELECT *
FROM person
SELECT *
FROM character
    INSERT
INTO character (character_name, description, role, actor_id, movie_id)
VALUES
    ('Cobb', 'The main character of the movie.', 'leading', 11, 1),
    ('Neo', 'The protagonist of the Matrix.', 'leading', 19, 2),
    ('Murphy Cooper', 'A scientist working in space.', 'supporting', 20, 3),
    ('Nina Sayers', 'A ballerina with psychological issues.', 'leading', 12, 4),
    ('Arthur Fleck', 'A struggling comedian who becomes the Joker.', 'leading', 18, 5),
    ('Hok Lok', 'Enemy.', 'supporting', 13, 5),
    ('Huj', 'Enk.', 'supporting', 13, 4);


select *
from file
select *
from actor
    INSERT
INTO person_file (file_id, person_id, is_primary)
VALUES
    (11, 1, TRUE),
    (12, 2, TRUE),
    (13, 3, TRUE),
    (14, 4, TRUE),
    (15, 5, TRUE);


