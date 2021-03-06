/*1*/
SELECT *
FROM	tblEmployee
WHERE	empSalary > 50000;

----------------------------------------------------------
/*2*/
SELECT	empName, empSalary
FROM	tblEmployee
WHERE	empSalary > 50000;

SELECT	*
FROM	tblEmployee

SELECT	TOP 5 *
FROM	tblEmployee

SELECT	*
FROM	tblEmployee

SELECT	TOP 50 PERCENT *
FROM	tblEmployee

SELECT	empAddress
FROM	tblEmployee

SELECT	DISTINCT empAddress
FROM	tblEmployee

----------------------------------------------------------
/*3*/
SELECT	empName AS 'Họ và Tên', empSalary AS 'Lương'
FROM	tblEmployee
WHERE	empSalary > 50000;

----------------------------------------------------------
/*4*/
SELECT 	empName AS 'HỌ và tên', empSex  AS 'Giớ tính' , YEAR(GETDATE()) - YEAR(empBirthdate) AS 'Tuổi'
FROM 	tblEmployee
WHERE 	(empSex='F' AND (YEAR(GETDATE()) - YEAR(empBirthdate)) < 40)
	OR
		(empSex='M' AND (YEAR(GETDATE()) - YEAR(empBirthdate)) < 50);

----------------------------------------------------------
/*5.1*/
SELECT 	*
FROM 	tblEmployee
WHERE 	empName = N'Võ Việt Anh';

----------------------------------------------------------
/*5.2*/
SELECT 	*
FROM 	tblEmployee
WHERE 	empName LIKE N'%Anh';

SELECT 	*
FROM 	tblEmployee
WHERE 	empName LIKE N'Nguyễn%';

----------------------------------------------------------
/*5.3 chuỗi có chứa dấu %*/
SELECT 	empName AS 'HỌ và tên', empSex  AS 'Giớ tính' , YEAR(GETDATE()) - YEAR(empBirthdate) AS 'Tuổi'
FROM 	tblEmployee
WHERE 	empName LIKE '%@%%' ESCAPE '@';

SELECT 	empName AS 'HỌ và tên', empSex  AS 'Giớ tính' , YEAR(GETDATE()) - YEAR(empBirthdate) AS 'Tuổi'
FROM 	tblEmployee
WHERE 	empName LIKE '%!%%' ESCAPE '!';

/*5.4 chuỗi bắt đầu và kết thúc với dấu % */
SELECT 	empName AS 'HỌ và tên', empSex  AS 'Giớ tính' , YEAR(GETDATE()) - YEAR(empBirthdate) AS 'Tuổi'
FROM 	tblEmployee
WHERE 	empName LIKE 'x%%x%' ESCAPE 'x';

----------------------------------------------------------
/* Trong SQL Server, không chỉ định từ khóa DATE cho chuỗi giá trị hằng ngày, mà chỉ đơn thuần là chuỗi 'yyyy-mm-dd' dạng ngày */
SELECT 	empName,empBirthdate, YEAR(GETDATE()) - YEAR(empBirthdate) AS 'Tuổi'
FROM 	tblEmployee
WHERE	empBirthdate='1968-02-17';

----------------------------------------------------------
/*6*/
SELECT 	*
FROM 	tblEmployee
ORDER BY depNum ASC, empSalary DESC;

----------------------------------------------------------
/*7*/
SELECT 	*
FROM 	tblEmployee, tblDepartment
WHERE	tblEmployee.depNum=tblDepartment.depNum AND tblDepartment.depName LIKE N'Phòng phần mềm trong nước';


SELECT 	*
FROM 	tblEmployee e, tblDepartment d
WHERE	e.depNum=d.depNum AND d.depName LIKE N'Phòng phần mềm trong nước';

----------------------------------------------------------
/*9*/
SELECT 	DISTINCT w1.proNum AS 'Project Number'
FROM 	tblWorksOn  w1, tblWorksOn  w2
WHERE	w1.proNum=w2.proNum AND w1.empSSN<>w2.empSSN

SELECT 	e1.empName AS 'Employee Name', e2.empName AS 'Supervisor Name', e1.supervisorSSN, e2.empSSN
FROM 	tblEmployee e1, tblEmployee e2
WHERE	e1.empName=N'Mai Duy An' AND e1.supervisorSSN=e2.empSSN

----------------------------------------------------------
/*10.1*/
SELECT 	* FROM tblEmployee WHERE empName LIKE 'H%'
UNION
SELECT 	* FROM tblEmployee WHERE empSalary > 80000

----------------------------------------------------------
/*10.2*/
SELECT 	empSSN FROM tblEmployee
EXCEPT
SELECT 	supervisorSSN FROM tblEmployee

----------------------------------------------------------
/*10.3*/
SELECT 	empSSN 
FROM 	tblWorksOn w, tblProject p
WHERE 	w.proNum=p.proNum AND p.proName='ProjectB'
INTERSECT
SELECT 	empSSN 
FROM 	tblWorksOn w, tblProject p
WHERE 	w.proNum=p.proNum AND p.proName='ProjectC'

----------------------------------------------------------
/*11*/
SELECT 	*
FROM 	tblEmployee e, tblDepartment d
WHERE	e.depNum=d.depNum AND d.depName LIKE N'Phòng phần mềm trong nước';
--
SELECT 	*
FROM 	tblEmployee
WHERE 	depNum = (SELECT depNum 
					FROM tblDepartment 
					WHERE depName=N'Phòng phần mềm trong nước');
SELECT 	*
FROM 	tblEmployee
WHERE 	depNum = ANY (SELECT depNum 
					FROM tblDepartment 
					WHERE depName=N'Phòng phần mềm trong nước');
SELECT 	*
FROM 	tblEmployee
WHERE 	depNum IN (SELECT depNum 
					FROM tblDepartment 
					WHERE depName=N'Phòng phần mềm trong nước');


--Nhân viên lương cao nhất/thấp nhất
SELECT 	*
FROM 	tblEmployee
WHERE 	empSalary>=ALL (SELECT  empSalary
					FROM  tblEmployee);

SELECT 	*
FROM 	tblEmployee
WHERE 	empSalary<=ALL (SELECT  empSalary
					FROM  tblEmployee);
----------------------------------------------------------
/*12*/
SELECT *
FROM 	tblProject 
WHERE 	locNum = (SELECT locNum
				FROM tblProject 
				WHERE proName='ProjectA');

----------------------------------------------------------
/*13*/
SELECT 	*
FROM 	tblEmployee
WHERE 	depNum = (SELECT depNum 
					FROM tblDepartment 
					WHERE depName=N'Phòng phần mềm trong nước');
--cùng kết quả
SELECT 	*
FROM 	tblEmployee e, (SELECT depNum 
					FROM tblDepartment 
					WHERE depName=N'Phòng phần mềm trong nước') d
WHERE 	e.depNum=d.depNum

----------------------------------------------------------
/*15.1 theta join with equation condition */
SELECT *
FROM tblDepartment d JOIN tblEmployee e ON d.depNum=e.depNum

SELECT *
FROM	tblDependent d JOIN tblEmployee e ON d.empSSN=e.empSSN

----------------------------------------------------------
/*15.2 theta join with other condition */
SELECT *
FROM	tblDependent d JOIN tblEmployee e ON d.empSSN<>e.empSSN

SELECT *
FROM	tblDependent d JOIN tblEmployee e ON d.empSSN>e.empSSN

----------------------------------------------------------
/*15.3 cross join */
SELECT *
FROM	tblDependent CROSS JOIN tblEmployee

----------------------------------------------------------
/*17.1*/
SELECT l.locNum, l.locName, p.proNum, p.proName
FROM tblLocation l LEFT OUTER JOIN tblProject p ON l.locNum=p.locNum

SELECT *
FROM	tblEmployee e LEFT OUTER JOIN tblDependent d ON e.empSSN=d.empSSN

SELECT *
FROM	tblDependent d RIGHT OUTER JOIN tblEmployee e ON e.empSSN=d.empSSN

----------------------------------------------------------
/*17.2*/
SELECT d.depName, p.proName
FROM tblDepartment d LEFT OUTER JOIN tblProject p ON d.depNum=p.depNum

----------------------------------------------------------
/*17.3*/
SELECT l.locNum, l.locName
FROM tblLocation l JOIN tblProject p ON l.locNum=p.locNum

SELECT l.locNum, l.locName
FROM tblLocation l JOIN tblProject p ON l.locNum=p.locNum

----------------------------------------------------------
/*18.1*/
SELECT AVG(empSalary) AS Average_Of_Salary
FROM tblEmployee

----------------------------------------------------------
/*18.2*/
SELECT COUNT(*) AS Count_Of_Employees
FROM tblEmployee

----------------------------------------------------------
/*19.1, 19.2*/
SELECT *
FROM tblEmployee
ORDER BY depNum

SELECT depNum, COUNT(empSSN) AS Num_Of_Employees
FROM 	tblEmployee
GROUP BY depNum
ORDER BY COUNT(*) ASC

SELECT depNum, COUNT(*) AS Num_Of_Employees
FROM 	tblEmployee
GROUP BY depNum
ORDER BY COUNT(*) ASC

----------------------------------------------------------
/*20*/
SELECT proNum, COUNT(empSSN) AS Number_Of_Employees, SUM(workHours) AS Total_OfworkHours
FROM  tblWorksOn 
GROUP BY proNum

----------------------------------------------------------
/*21*/
SELECT depNum, AVG(empSalary)  AS Average_Of_Salary
FROM  tblEmployee
GROUP BY depNum
HAVING AVG(empSalary) > 80000

SELECT proNum, COUNT(empSSN) AS Number_Of_Employees, SUM(workHours) AS Total_OfworkHours
FROM  tblWorksOn 
GROUP BY proNum
HAVING COUNT(empSSN)>4

SELECT proNum, COUNT(empSSN) AS Number_Of_Employees, SUM(workHours) AS Total_OfworkHours
FROM  tblWorksOn 
GROUP BY proNum
HAVING AVG(workHours)>20

SELECT proNum, COUNT(empSSN) AS Number_Of_Employees, SUM(workHours) AS Total_OfworkHours
FROM  tblWorksOn 
GROUP BY proNum
HAVING proNum=4

----------------------------------------------------------
/*22*/
SELECT	* 
FROM	tblDepartment

INSERT INTO tblDepartment(depNum,depName)
VALUES(6, N'Phòng Kế Toán');

SELECT	* 
FROM	tblDepartment

INSERT INTO tblDepartment
VALUES(7, N'Phòng Nhân Sự', NULL, NULL);

SELECT	* 
FROM	tblDepartment

----------------------------------------------------------
/*23*/
DELETE 
FROM	tblDepartment
WHERE	depName=N'Phòng Kế Toán'

DELETE 
FROM	tblDepartment
WHERE	depNum=7

SELECT	* 
FROM	tblDepartment

----------------------------------------------------------
/*24*/
SELECT	*
FROM	tblEmployee
WHERE	empName=N'Mai Duy An'

UPDATE	tblEmployee
SET		empSalary=empSalary+5000, depNum=2
WHERE	empName=N'Mai Duy An'

----------------------------------------------------------
/*25*/
SELECT	empName, empSalary
FROM	tblEmployee
WHERE	depNum IN
				(SELECT	depNum
				FROM	tblDepartment
				WHERE	depName=N'Phòng Phần mềm trong nước')

UPDATE	tblEmployee
SET	empSalary=empSalary*1.1
WHERE	depNum IN
				(SELECT	depNum
				FROM	tblDepartment
				WHERE	depName=N'Phòng Phần mềm trong nước')

















