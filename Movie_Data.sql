create database movie_data;
use movie_data;
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    ReleaseYear INT,
    Rating DECIMAL(3, 1)
);

INSERT INTO Movies VALUES 
(1, 'The Shawshank Redemption', 'Drama', 1994, 9.3),
(2, 'The Godfather', 'Crime', 1972, 9.2),
(3, 'The Dark Knight', 'Action', 2008, 9.0),
(4, 'Forrest Gump', 'Drama', 1994, 8.8),
(5, 'Inception', 'Sci-Fi', 2010, 8.7),
(6, 'Fight Club', 'Drama', 1999, 8.8),
(7, 'Interstellar', 'Sci-Fi', 2014, 8.6),
(8, 'Pulp Fiction', 'Crime', 1994, 8.9);
select * from Movies;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100)
);

INSERT INTO Customers VALUES 
(1, 'Alice Smith', '1234567890', 'alice@example.com'),
(2, 'Bob Johnson', '2345678901', 'bob@example.com'),
(3, 'Charlie Brown', '3456789012', 'charlie@example.com'),
(4, 'Daisy Lee', '4567890123', 'daisy@example.com'),
(5, 'Edward Carter', '5678901234', 'edward@example.com');

select * from Customers;
CREATE TABLE Rentals (
    RentalID INT PRIMARY KEY,
    MovieID INT,
    CustomerID INT,
    RentalDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Rentals VALUES 
(1, 1, 1, '2025-01-05', '2025-01-10'),
(2, 3, 2, '2025-01-06', NULL),
(3, 5, 1, '2025-01-03', '2025-01-07'),
(4, 4, 3, '2025-01-04', '2025-01-08'),
(5, 7, 4, '2025-01-05', NULL),
(6, 6, 2, '2025-01-01', '2025-01-06');

select * from Rentals;

-- 1. List all movies and their details
SELECT 
    *
FROM
    Movies;

-- 2 Show customers who have not returned their rentals

select Name, Title ,RentalID, RentalDate 
From Rentals
Join 
Customers ON Customers.CustomerID = Rentals.CustomerID
Join
Movies ON Movies.MovieID = Rentals.MovieID
where ReturnDate is null;


-- 3 Find the most rented movie(s)
SELECT 
    Title, COUNT(Rentals.MovieID) AS RentalCount
FROM
    Rentals
        JOIN
    Movies ON Movies.MovieID = Rentals.MovieID
GROUP BY Title
ORDER BY RentalCount DESC
LIMIT 1;

-- 4. List all rentals for a specific customer (e.g., Alice Smith)

SELECT 
    RentalID, Title, RentalDate, ReturnDate
FROM
    Rentals
        JOIN
    Movies ON Movies.MovieID = Rentals.MovieID
        JOIN
    Customers ON Customers.CustomerID = Rentals.CustomerID
WHERE
    Name = 'Alice Smith';

-- 5. Show the total number of movies rented by genre
SELECT 
    Genre, COUNT(Rentals.MovieID) AS RentalCount
FROM
    Rentals
        JOIN
    Movies ON Movies.MovieID = Rentals.MovieID
GROUP BY Genre
ORDER BY RentalCount DESC;

-- 6. Retrieve all customers who rented movies in the year 2025
SELECT 
    Name, Email
FROM
    Rentals
        JOIN
    Customers ON Customers.CustomerID = Rentals.CustomerID
WHERE
    YEAR(Rentals.RentalDate) = 2025;

-- 7. Calculate the total number of rentals for each customer
SELECT 
    Name, COUNT(Rentals.RentalID) AS TotalRentals
FROM
    Rentals
        JOIN
    Customers ON Customers.CustomerID = Rentals.CustomerID
GROUP BY Name
ORDER BY TotalRentals DESC;

-- 8. Find the movies released before the year 2000

SELECT 
    Title, ReleaseYear
FROM
    Movies
WHERE
    ReleaseYear < 2000;

-- 9 Find the highest-rated movies in each genre
SELECT 
    M.Genre, 
    M.Title, 
    M.Rating AS HighestRating
FROM 
    Movies M
WHERE 
    M.Rating = (
        SELECT MAX(Rating)
        FROM Movies
        WHERE Genre = M.Genre
    );
    
    -- 10. List customers who rented more than 2 movies
SELECT 
    Customers.Name, 
    COUNT(Rentals.RentalID) AS TotalRentals 
FROM 
    Rentals
JOIN 
    Customers ON Rentals.CustomerID = Customers.CustomerID
GROUP BY 
    Customers.Name
HAVING 
    TotalRentals < 2;

