
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100)
);
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Credits INT
);
CREATE TABLE Semesters (
    SemesterID INT PRIMARY KEY,
    SemesterName VARCHAR(50)
);
CREATE TABLE Grades (
    GradeID SERIAL PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    SemesterID INT,
    Marks INT,
    Grade CHAR(2),
    GPA DECIMAL(4,2),
    FOREIGN KEY (StudentID) REFERENCES Students (StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses (CourseID),
    FOREIGN KEY (SemesterID) REFERENCES Semesters (SemesterID)
);
INSERT INTO Students VALUES (1, 'Swetha'), (2, 'Saru'), (3, 'Mahi');
INSERT INTO Courses VALUES 
(101, 'DBMS', 4), 
(102, 'Java', 3), 
(103, 'OS', 3);
INSERT INTO Semesters VALUES 
(1, 'Semester 1'), 
(2, 'Semester 2');
INSERT INTO Grades (StudentID, CourseID, SemesterID, Marks, Grade)
VALUES
(1, 101, 1, 85, 'A'), (1, 102, 1, 70, 'B'), (1, 103, 1, 90, 'A'),
(2, 101, 1, 60, 'C'), (2, 102, 1, 75, 'B'), (2, 103, 1, 80, 'B'),
(3, 101, 1, 50, 'D'), (3, 102, 1, 40, 'F'), (3, 103, 1, 65, 'C');
CREATE VIEW GradePoints1 AS
SELECT 
    GradeID,
    StudentID,
    CourseID,
    SemesterID,
    Marks,
    Grade,
    CASE Grade
        WHEN 'A' THEN 10
        WHEN 'B' THEN 8
        WHEN 'C' THEN 6
        WHEN 'D' THEN 4
        WHEN 'F' THEN 0
    END AS GradePoint
FROM Grades;
CREATE VIEW StudentGPA1 AS
SELECT 
    g.StudentID,
    s.StudentName,
    g.SemesterID,
    ROUND ( SUM ( c.Credits * 
        CASE g.Grade
            WHEN 'A' THEN 10
            WHEN 'B' THEN 8
            WHEN 'C' THEN 6
            WHEN 'D' THEN 4
            WHEN 'F' THEN 0
        END
    ) ::DECIMAL ) / SUM (c.Credits), 2 ) AS GPA
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Courses c ON g.CourseID = c.CourseID
GROUP BY g.StudentID, s.StudentName, g.SemesterID;
SELECT 
    SemesterID,
    StudentID,
    GPA,
    RANK() OVER (PARTITION BY SemesterID ORDER BY GPA DESC) AS RankPosition
FROM StudentGPA1;
SELECT 
    StudentID,
    COUNT(*) AS TotalCourses,
    SUM(CASE WHEN Grade = 'F' THEN 1 ELSE 0 END) AS FailCount,
    CASE 
        WHEN SUM(CASE WHEN Grade = 'F' THEN 1 ELSE 0 END) > 0 THEN 'Fail'
        ELSE 'Pass'
    END AS ResultStatus
FROM Grades
GROUP BY StudentID;
CREATE VIEW SemesterSummary1 AS
SELECT 
    g.StudentID,
    s.StudentName,
    sem.SemesterName,
    g.CourseID,
    c.CourseName,
    g.Marks,
    g.Grade
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Courses c ON g.CourseID = c.CourseID
JOIN Semesters sem ON g.SemesterID = sem.SemesterID;
SELECT * FROM StudentGPA1;
SELECT * FROM GradePoints1;
SELECT * FROM SemesterSummary1;
SELECT 
    StudentID,
    COUNT(*) AS TotalCourses,
    SUM(CASE WHEN Grade = 'F' THEN 1 ELSE 0 END) AS FailCount,
    CASE 
        WHEN SUM(CASE WHEN Grade = 'F' THEN 1 ELSE 0 END) > 0 THEN 'Fail'
        ELSE 'Pass'
    END AS ResultStatus
FROM Grades
GROUP BY StudentID;
SELECT 
    SemesterID,
    StudentID,
    GPA,
    RANK() OVER (PARTITION BY SemesterID ORDER BY GPA DESC) AS RankPosition
FROM StudentGPA1;