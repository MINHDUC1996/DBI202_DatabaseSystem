USE I2DBCOMPANY
GO

----------------------------------------------------------
/* create view : liệt kê tất cả nhân viên thuộc phòng 1 */
IF OBJECT_ID('Employee_Dep1', 'V') IS NOT NULL
	DROP VIEW Employee_Dep1
go

CREATE VIEW Employee_Dep1 AS
	SELECT * FROM tblEmployee WHERE depNum=1;
go

----------------------------------------------------------
/* Truy vấn trên view Employee_Dep1 */
SELECT * FROM Employee_Dep1
GO
-- cùng kết quả với 
SELECT * FROM tblEmployee e WHERE e.depNum=1;
go

--Truy vấn kết view với bảng khác tương đồng với việc thực hiện truy vấn dùng định nghĩa view như một truy vấn con
SELECT * 
FROM Employee_Dep1 ed1, tblDependent d
WHERE ed1.empSSN=d.empSSN
GO

SELECT * 
FROM  (SELECT * 
       FROM tblEmployee 
       WHERE depNum=1
      ) ed1, tblDependent d
WHERE ed1.empSSN=d.empSSN
go

----------------------------------------------------------
/* Tạo view với các tên thuộc tính khác với tên thuộc tính trong bảng*/
IF OBJECT_ID('Employee_Dep1', 'V') IS NOT NULL
	DROP VIEW Employee_Dep1
go

CREATE VIEW Employee_Dep1 AS
	SELECT e.empSSN AS 'Mã số NV', e.empName AS 'Họ và tên',
		YEAR(GETDATE()) - YEAR(e.empBirthdate) AS 'Tuổi',
		e.empSalary AS 'Lương',
		CASE WHEN e.empSex='F' THEN N'Nữ' ELSE N'Nam' END AS 'Giới tính'
	FROM tblEmployee e WHERE e.depNum=1;
go

SELECT * FROM Employee_Dep1

----------------------------------------------------------
/* Thao tác trên View */
IF OBJECT_ID('Employee_Dep2', 'V') IS NOT NULL
	DROP VIEW Employee_Dep2
go

CREATE VIEW Employee_Dep2 AS
	SELECT e.empSSN, e.empName, e.empSalary, e.empSex
	FROM tblEmployee e WHERE e.depNum=1;
go
-- test modification on based table
SELECT * FROM tblEmployee e WHERE e.empSSN=10000
INSERT INTO tblEmployee(empSSN, empName, empSalary, empSex, depNum)
VALUES (10000, N'Nguyễn Văn ABC', 50000, 'M', 1)

SELECT * FROM tblEmployee e WHERE e.depNum=1
SELECT * FROM Employee_Dep2
-- test modification on based table
DELETE tblEmployee WHERE empSSN=10000
SELECT * FROM tblEmployee e WHERE e.depNum=1
SELECT * FROM Employee_Dep2

-- test modification on view
INSERT INTO Employee_Dep2 
VALUES (10001, N'Nguyễn Văn ABC', 50000, 'M')

-- Không thấy bộ vừa thêm vào vì depNum là NULL chứ không như mong chờ là 1
SELECT * FROM tblEmployee e WHERE e.depNum=1
SELECT * FROM Employee_Dep2
-- 
SELECT * FROM tblEmployee e WHERE empSSN=10001
DELETE tblEmployee WHERE empSSN=10001

----------------------------------------------------------
/* update view error */
IF OBJECT_ID('Employee_Dep3', 'V') IS NOT NULL
	DROP VIEW Employee_Dep3
go

CREATE VIEW Employee_Dep3 AS
	SELECT e.empSSN AS 'Mã số NV', e.empName AS 'Họ và tên',
		YEAR(GETDATE()) - YEAR(e.empBirthdate) AS 'Tuổi',
		e.empSalary AS 'Lương',
		CASE WHEN e.empSex='F' THEN N'Nữ' ELSE N'Nam' END AS 'Giới tính'
	FROM tblEmployee e WHERE e.depNum=1;
go

SELECT * FROM Employee_Dep3
INSERT INTO Employee_Dep3 
VALUES (10003, N'Nguyễn Văn ABC', 20, 50000, 'M')

----------------------------------------------------------
/* Trigger trên view */
IF OBJECT_ID('Tr_Employee_Insert', 'TR') IS NOT NULL
	DROP TRIGGER Tr_Employee_Insert
go
CREATE TRIGGER Tr_Employee_Insert ON tblEmployee
AFTER INSERT
AS
	DECLARE @vEmpSSN DECIMAL, @vEmpName NVARCHAR(50)
	SELECT @vEmpSSN=empSSN FROM inserted
	SELECT @vEmpName=empName FROM inserted
     
     PRINT 'INSERT TRIGGER'
	PRINT 'empSSN=' + CAST(@vEmpSSN AS nvarchar(11)) + ' empName=' + @vEmpName
GO

--
IF OBJECT_ID('Employee_Dep1', 'V') IS NOT NULL
	DROP VIEW Employee_Dep1
go

CREATE VIEW Employee_Dep1 AS
	SELECT e.empSSN, e.empName, e.empSalary, e.empSex
	FROM tblEmployee e WHERE e.depNum=1;
go

-- 
IF OBJECT_ID('Employee_Dep1', 'V') IS NOT NULL
	DROP VIEW Employee_Dep1
go

CREATE VIEW Employee_Dep1 AS
	SELECT e.empSSN, e.empName, e.empSalary, e.empSex
	FROM tblEmployee e WHERE e.depNum=1;
go

--
IF OBJECT_ID('TR_Employee_Dep1', 'TR') IS NOT NULL
	DROP TRIGGER TR_Employee_Dep1
go

CREATE TRIGGER TR_Employee_Dep1 ON Employee_Dep1 INSTEAD OF INSERT
AS
   DECLARE @SSN DECIMAL(18,0), 
           @name NVARCHAR(50),
           @salary  DECIMAL(18,0), 
           @sex CHAR(1)
   SELECT @SSN=empSSn, @name=empName, @salary=empSalary, @sex=empSex 
   FROM INSERTED
   
   --PRINT 'INSTEAD OF TRIGGER'

   INSERT INTO tblEmployee(empSSN, empName, empSalary, empSex, depNum)
   VALUES(@SSN, @name, @salary, @sex, 1)
GO

-- test: khi thực hiện tác vụ INSERT trigger gắn kết với view sẽ được thực hiện 
-- và tác vụ INSERT là nguyên nhân gây ra trigger sẽ không được thực hiện
SELECT * FROM Employee_Dep1
INSERT INTO Employee_Dep1 
VALUES (10009, N'Nguyễn Văn ABC', 50000, 'M')

SELECT * FROM Employee_Dep1
SELECT * FROM tblEmployee WHERE empSSN=10009
DELETE tblEmployee WHERE empSSN=10009


----------------------------------------------------------
/**/

----------------------------------------------------------
/**/

----------------------------------------------------------
/**/

----------------------------------------------------------
/**/

----------------------------------------------------------
/**/

