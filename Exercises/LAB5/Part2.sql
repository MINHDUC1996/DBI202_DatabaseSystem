﻿USE [FUH_UNIVERSITY]

-------------------------------------------------
IF OBJECT_ID('pro_Student_Department','P') IS NOT NULL
	DROP PROCEDURE pro_Student_Department
GO

CREATE PROCEDURE pro_Student_Department
	@deptName nvarchar(50),
	@year INT
AS
	SELECT *
	FROM tblStudent
	WHERE claCode IN
					(SELECT claCode
					FROM tblClass
					WHERE claCode IN
									(SELECT claCode
									FROM tblSection
									WHERE secYear = @year)
					AND depCode IN
									(SELECT depCode
									FROM tblDepartment
									WHERE depName LIKE @deptName)
					)
GO
---
EXEC pro_Student_Department N'Department of information technologies', 2010
-------------------------------------------------

IF OBJECT_ID('pro_Subject_Prequisites','P') IS NOT NULL
	DROP PROCEDURE pro_Subject_Prequisites
GO

CREATE PROCEDURE pro_Subject_Prequisites 
	@subject nvarchar(50)
AS
	SELECT *
	FROM tblPrequisites
	WHERE subPosCode IN
					(SELECT subCode
					FROM tblSubject
					WHERE subName LIKE @subject)
	OR subPreCode IN
					(SELECT subCode
					FROM tblSubject
					WHERE subName LIKE @subject)
GO

---
EXEC pro_Subject_Prequisites 'Project Management'

-------------------------------------------------

IF OBJECT_ID('pro_Retaken_Students','P') IS NOT NULL
	DROP PROCEDURE pro_Retaken_Students
GO

CREATE PROCEDURE pro_Retaken_Students
	@subject nvarchar(50),
	@semester int,
	@year int
AS
	SELECT DISTINCT stuCode
	FROM tblReport
	WHERE secCode IN
					(SELECT secCode
					FROM tblSection
					WHERE subCode IN
									(SELECT subCode
									FROM tblSubject
									WHERE subName LIKE @subject)
					AND secSemester = @semester
					AND secYear = @year)
	AND repStatus = N'R'
GO

---
EXEC pro_Retaken_Students N'Data Structures and Algorithms', 1, 2010

-------------------------------------------------

IF OBJECT_ID('pro_Update_Grades','p') IS NOT NULL
	DROP PROCEDURE pro_Update_Grades 
GO

CREATE PROCEDURE pro_Update_Grades 
	@name nvarchar(50),
	@subject nvarchar(50),
	@theory int,
	@practicle int
AS
	UPDATE tblReport
	SET repTheory = @theory, repPracticle = @practicle
	WHERE stuCode IN
					(SELECT stuCode
					FROM tblStudent
					WHERE stuName = @name)
	AND secCode IN
					(SELECT secCode
					FROM tblSection
					WHERE subCode IN
									(SELECT subCode
									FROM tblSubject
									WHERE subName LIKE @subject)
					)
GO

---
EXEC pro_Update_Grades N'Lê Nguyễn Hoài An' , N'Data Structures and Algorithms', 9, 9