**Student-Result-Processing-to-manage-grades-and-CGPA-System**
**Student Result Processing System**
A SQL-based project designed to manage student grades, calculate GPA/CGPA, and generate academic performance reports using MySQL.
**Project Objective**
To create a relational database system that:
- Stores student, course, and grade information
- Calculates GPA and CGPA
- Generates rank lists
- Tracks academic performance efficiently using SQL queries and logic
**Tools & Technologies**
- **Database**: MySQL
- **Client**: MySQL Workbench / Command Line Interface
- **Language**: SQL
  **Database Schema**
**Tables**
- **Students**: Stores student personal and academic details
- **Courses**: Contains course codes and credit information
- **Grades**: Stores grade details for each course
- **Semesters**: Information about academic semesters
- **StudentGrades**: Junction table linking students, courses, semesters, and grades

**GPA/CGPA Calculation Logic**

GPA is calculated using the formula:

ROUND(SUM(C.Credits * 
  
  CASE G.Grade
    WHEN 'A' THEN 10
    WHEN 'B' THEN 8
    WHEN 'C' THEN 6
    WHEN 'D' THEN 4
    WHEN 'F' THEN 0
  END)::DECIMAL / SUM(C.Credits), 2) AS GPA
