-- Create Databse movie_manager
CREATE DATABASE movie_manager;

-- Use Databse
USE movie_manager;

-- Create theater table
CREATE TABLE Theater (
	theater_id INT PRIMARY KEY AUTO_INCREMENT,
    theater_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

-- Insert data into theater table

INSERT INTO Theater (theater_name, location)
VALUES
	("INOX-1", "Delhi"),
    ("PVR", "Mumbai"),
    ("Cinepolis", "Bangalore" );
    
-- Get all Theater
SELECT * FROM Theater;
    
-- Genre Table
CREATE TABLE Genre (
	genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(255) UNIQUE NOT NULL
);

-- Insert Genres
INSERT INTO Genre (genre_name) VALUES
	("Action"),
    ("Adventure"),
    ("Drama"),
    ("Thriller"),
    ("Sci-Fi");
    
-- Get all genre
SELECT * FROM Genre;



-- Create a Movie Table
CREATE TABLE Movie (
	movie_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_name VARCHAR(255) NOT NULL,
    duration_in_minutes INT NOT NULL,
    language VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL
);

-- Insert Movies
INSERT INTO Movie (movie_name, duration_in_minutes, language, release_date)
	VALUES
		("Movie-1", 120, "English", "2025-01-01"),
        ("Movie-2", 125, "Hindi", "2025-01-02"),
        ("Movie-3", 130, "Telgu", "2025-01-03"),
        ("Movie-4", 140, "Maithili", "2025-01-04"),
        ("Movie-5", 150, "Marathi", "2025-01-05");
        
-- Get all Movie
SELECT * FROM Movie;


-- Table for Movie-Genre Relationship
CREATE TABLE Movie_Genre (
	genre_id INT,
    movie_id INT,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE
);

-- Relate Movie with Genre
-- Movie-1 is Action and Adventure
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
	(1, 1),
    (1, 2);
    
-- Movie-2 is Action Thriller
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
	(2, 1),
    (2, 4);

-- Movie-3 is Drama 
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
	(3, 3);

-- Movie-4 is Action Thriller Sci-Fi
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
	(4, 1),
    (4, 4),
    (4, 5);

-- Movie-5 is Action Thriller
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
	(5, 1),
    (5, 4);
    
SELECT * FROM Movie_Genre;

    
-- Create show table
CREATE TABLE Movie_Show (
	show_id INT PRIMARY KEY AUTO_INCREMENT,
    theater_id INT,
    movie_id INT,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    format VARCHAR(20),
    FOREIGN KEY (theater_id) REFERENCES Theater(theater_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE
);

SELECT * FROM Theater;

-- Insert into Movie_Show
INSERT INTO Movie_Show (theater_id, movie_id, show_date, show_time, format)
VALUES 
    (1, 1, '2024-04-25', '12:15:00', '2D'),
    (1, 2, '2024-04-25', '13:00:00', '2D'),
    (2, 2, '2024-04-25', '16:10:00', '2D'),
    (3, 2, '2024-04-25', '18:20:00', '2D'),
    (2, 3, '2024-04-25', '13:16:00', '2D'),
    (1, 4, '2024-04-25', '13:20:00', '3D');

    
-- Fetch Movie With there Genre
SELECT 
    M.movie_name, 
    GROUP_CONCAT(G.genre_name SEPARATOR ', ') AS genres
FROM Movie M
JOIN Movie_Genre MG ON M.movie_id = MG.movie_id
JOIN Genre G ON MG.genre_id = G.genre_id
GROUP BY M.movie_id, M.movie_name;

-- Fetch Genre theater and show time
SELECT 
    M.movie_name, 
    GROUP_CONCAT(DISTINCT G.genre_name ORDER BY G.genre_name SEPARATOR ', ') AS genres,
    T.theater_name, 
    S.show_date, 
    S.show_time, 
    S.format
FROM Movie M
JOIN Movie_Genre MG ON M.movie_id = MG.movie_id
JOIN Genre G ON MG.genre_id = G.genre_id
JOIN Movie_Show S ON M.movie_id = S.movie_id
JOIN Theater T ON S.theater_id = T.theater_id
GROUP BY M.movie_id, M.movie_name, T.theater_name, S.show_date, S.show_time, S.format
ORDER BY S.show_date, S.show_time;

-- Fetch All Moview in a theater
SELECT DISTINCT M.movie_name
FROM Movie_Show S
JOIN Movie M ON S.movie_id = M.movie_id
JOIN Theater T ON S.theater_id = T.theater_id
WHERE S.show_date = "2024-04-25" and T.theater_name = "INOX-1"; 

-- List Show Timing for a particular Movie at a given Theater on a Given date
SELECT M.movie_name, S.show_time, S.format
FROM Movie_Show S
JOIN Movie M ON S.movie_id = M.movie_id
JOIN Theater T on S.theater_id = T.theater_id
WHERE S.show_date = "2024-04-25" AND T.theater_name = "INOX-1" AND M.movie_name="movie-1";

-- Moview of a Genre
SELECT DISTINCT M.movie_name
FROM Movie M
JOIN Movie_Genre MG ON M.movie_id = MG.Movie_id
JOIN Genre G ON MG.genre_id = G.genre_id
WHERE G.genre_name = "Action";

