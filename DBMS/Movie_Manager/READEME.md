# **Movie Ticket Booking System - Database Setup Guide**  

This document provides step-by-step instructions to set up the **Movie Ticket Booking System** using MySQL. It includes creating and populating the necessary tables following **1NF, 2NF, 3NF, and BCNF** database normalization rules.

---

## **Step 1: Create the Database**
```sql
CREATE DATABASE movie_manager;
USE movie_manager;
```
This command creates a new database and switches to it for further operations.

---

## **Step 2: Create the Theater Table**
```sql
CREATE TABLE Theater (
    theater_id INT PRIMARY KEY AUTO_INCREMENT,
    theater_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);
```
This table stores theater details with a unique `theater_id` as the primary key.

### **Insert Sample Data**
```sql
INSERT INTO Theater (theater_name, location)
VALUES
    ("INOX-1", "Delhi"),
    ("PVR", "Mumbai"),
    ("Cinepolis", "Bangalore");
```
This command inserts three theaters into the database.

---

## **Step 3: Create the Genre Table**
```sql
CREATE TABLE Genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(255) UNIQUE NOT NULL
);
```
The `Genre` table stores different movie genres with a unique `genre_id`.

### **Insert Sample Genres**
```sql
INSERT INTO Genre (genre_name) 
VALUES 
    ("Action"),
    ("Adventure"),
    ("Drama"),
    ("Thriller"),
    ("Sci-Fi");
```
This command inserts five genres into the genre table.

---

## **Step 4: Create the Movie Table**
```sql
CREATE TABLE Movie (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_name VARCHAR(255) NOT NULL,
    duration_in_minutes INT NOT NULL,
    language VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL
);
```
This table stores movies with attributes such as `duration`, `language`, and `release_date`.

### **Insert Sample Movies**
```sql
INSERT INTO Movie (movie_name, duration_in_minutes, language, release_date)
VALUES
    ("Movie-1", 120, "English", "2025-01-01"),
    ("Movie-2", 125, "Hindi", "2025-01-02"),
    ("Movie-3", 130, "Telugu", "2025-01-03"),
    ("Movie-4", 140, "Maithili", "2025-01-04"),
    ("Movie-5", 150, "Marathi", "2025-01-05");
```
This command inserts five movies into the movie table.

---

## **Step 5: Create the Movie-Genre Relationship Table**
```sql
CREATE TABLE Movie_Genre (
    genre_id INT,
    movie_id INT,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE
);
```
Since a movie can belong to multiple genres, this bridge table establishes a **many-to-many** relationship between `Movie` and `Genre`.

### **Insert Sample Movie-Genre Relationships**
```sql
-- Movie-1 is Action and Adventure
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
    (1, 1),
    (1, 2);

-- Movie-2 is Action and Thriller
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
    (2, 1),
    (2, 4);

-- Movie-3 is Drama
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
    (3, 3);

-- Movie-4 is Action, Thriller, and Sci-Fi
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
    (4, 1),
    (4, 4),
    (4, 5);

-- Movie-5 is Action and Thriller
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES
    (5, 1),
    (5, 4);
```
This inserts **movie-genre associations**, mapping each movie to its respective genres.

---

## **Step 6: Create the Movie Show Table**
```sql
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
```
This table stores **shows scheduled in different theaters** on different dates and times.

### **Insert Sample Show Data**
```sql
INSERT INTO Movie_Show (theater_id, movie_id, show_date, show_time, format)
VALUES
    (1, 1, '2024-04-25', '12:15:00', '2D'),
    (1, 2, '2024-04-25', '13:00:00', '2D'),
    (2, 2, '2024-04-25', '16:10:00', '2D'),
    (3, 2, '2024-04-25', '18:20:00', '2D'),
    (2, 3, '2024-04-25', '13:16:00', '2D'),
    (1, 4, '2024-04-25', '13:20:00', '3D');
```
This command inserts movie shows into the system with **theater, movie, date, time, and format details**.

---

## **Step 7: Fetch Movies With Their Genres**
To retrieve a complete list of movies along with their genres:
```sql
SELECT 
    M.movie_name, 
    GROUP_CONCAT(G.genre_name SEPARATOR ', ') AS genres
FROM Movie M
JOIN Movie_Genre MG ON M.movie_id = MG.movie_id
JOIN Genre G ON MG.genre_id = G.genre_id
GROUP BY M.movie_id, M.movie_name;
```
This query returns **movie names and their associated genres** in a comma-separated format.

### **Expected Output**
| Movie Name | Genres                  |
|------------|-------------------------|
| Movie-1    | Action, Adventure       |
| Movie-2    | Action, Thriller        |
| Movie-3    | Drama                   |
| Movie-4    | Action, Thriller, Sci-Fi |
| Movie-5    | Action, Thriller        |

---

## **Step 8: Fetch Movie Show Details**
To list all movies playing in theaters along with their showtimes:
```sql
SELECT 
    M.movie_name, 
    T.theater_name, 
    S.show_date, 
    S.show_time, 
    S.format
FROM Movie_Show S
JOIN Movie M ON S.movie_id = M.movie_id
JOIN Theater T ON S.theater_id = T.theater_id
ORDER BY S.show_date, S.show_time;
```
This query returns **movie schedules across different theaters** ordered by date and time.

---

## **Step 9: Fetch Movies Playing in a Specific Theater on a Given Date**
```sql
SELECT 
    M.movie_name, 
    S.show_time, 
    S.format
FROM Movie_Show S
JOIN Movie M ON S.movie_id = M.movie_id
JOIN Theater T ON S.theater_id = T.theater_id
WHERE S.show_date = '2024-04-25' 
AND T.theater_name = 'PVR';
```
This query retrieves **all movies playing at "PVR" on April 25, 2024**, along with their **showtimes and formats**.

---