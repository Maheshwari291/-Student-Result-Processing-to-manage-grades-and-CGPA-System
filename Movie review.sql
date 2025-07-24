
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    UserName VARCHAR(100),
    Age INT,
    Gender VARCHAR(10)
);

CREATE TABLE Movies (
    MovieID SERIAL PRIMARY KEY,
    Title VARCHAR(200),
    Genre VARCHAR(50),
    ReleaseYear INT
);

CREATE TABLE Ratings (
    RatingID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    MovieID INT REFERENCES Movies(MovieID),
    Rating NUMERIC(2,1),  -- e.g., 8.5
    RatingDate DATE
);


CREATE TABLE Reviews (
    ReviewID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    MovieID INT REFERENCES Movies(MovieID),
    ReviewText TEXT,
    ReviewDate DATE
);


INSERT INTO Users (UserName, Age, Gender) VALUES
('Swetha', 25, 'Female'),
('Ravi', 30, 'Male'),
('Neha', 22, 'Female'),
('Arun', 28, 'Male');

INSERT INTO Movies (Title, Genre, ReleaseYear) VALUES
('Inception', 'Sci-Fi', 2010),
('The Godfather', 'Crime', 1972),
('Titanic', 'Romance', 1997),
('Interstellar', 'Sci-Fi', 2014);

INSERT INTO Ratings (UserID, MovieID, Rating, RatingDate) VALUES
(1, 1, 9.0, '2023-01-01'),
(2, 1, 8.5, '2023-01-02'),
(3, 2, 9.5, '2023-01-03'),
(4, 3, 8.0, '2023-01-04'),
(1, 4, 9.2, '2023-01-05');

INSERT INTO Reviews (UserID, MovieID, ReviewText, ReviewDate) VALUES
(1, 1, 'Amazing mind-bending movie!', '2023-01-01'),
(2, 1, 'Very intelligent and well-directed.', '2023-01-02'),
(3, 2, 'A classic. Brilliance in every scene.', '2023-01-03'),
(4, 3, 'Romantic and tragic.', '2023-01-04');

SELECT 
    m.Title, 
    ROUND(AVG(r.Rating), 2) AS AvgRating,
    COUNT(r.Rating) AS TotalRatings
FROM 
    Movies m
JOIN 
    Ratings r ON m.MovieID = r.MovieID
GROUP BY 
    m.Title
ORDER BY 
    AvgRating DESC;

SELECT 
    m.Title, 
    ROUND(AVG(r.Rating), 2) AS AvgRating
FROM 
    Movies m
JOIN 
    Ratings r ON m.MovieID = r.MovieID
GROUP BY 
    m.Title
ORDER BY 
    AvgRating DESC
LIMIT 3;

CREATE VIEW RecommendedMovies AS
SELECT 
    m.MovieID,
    m.Title,
    ROUND(AVG(r.Rating), 2) AS AvgRating,
    COUNT(r.Rating) AS NumRatings
FROM 
    Movies m
JOIN 
    Ratings r ON m.MovieID = r.MovieID
GROUP BY 
    m.MovieID, m.Title
HAVING 
    AVG(r.Rating) > 8.5;

SELECT 
    Title,
    Genre,
    ReleaseYear,
    ROUND(AVG(Rating), 2) AS AvgRating,
    RANK() OVER (ORDER BY AVG(Rating) DESC) AS Rank
FROM 
    Movies m
JOIN 
    Ratings r ON m.MovieID = r.MovieID
GROUP BY 
    m.MovieID
ORDER BY 
    Rank;

SELECT * FROM RecommendedMovies;


