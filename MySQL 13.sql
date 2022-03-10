#存储过程 与 存储函数
CREATE DATABASE dbtest15;

CREATE TABLE employees
AS
SELECT *
FROM atguigudb.`employees`;

CREATE TABLE departments
AS
SELECT *
FROM atguigudb.`departments`;

#创建存储过程

#类型一：无参数无返回值
#创建存储过程select_all_data()，查看employees表的所有数据
DELIMITER $
CREATE PROCEDURE select_all_data()
BEGIN 
	SELECT * FROM employees;
END $

DELIMITER;

#调用存储过程
CALL select_all_data();

#创建存储过程avg_employee_salary()，返回所有员工的平均工资
DELIMITER $
CREATE PROCEDURE avg_employee_salary()
BEGIN 
	SELECT AVG(salary) FROM employees;
END $
DELIMITER ;

CALL avg_employee_salary();

#创建存储过程show_max_salary()，用来查看“emps”表的最高薪资值。
DELIMITER $
CREATE PROCEDURE show_max_salary()
BEGIN 
	SELECT MAX(salary) FROM employees;
END $
DELIMITER ;

CALL show_max_salary();

#类型二：带OUT
#创建存储过程show_min_salary()，查看“emps”表的最低薪资值。并将最低薪资通过OUT参数“ms”输出
DESC employees;
DELIMITER $
CREATE PROCEDURE show_min_salary(OUT ms DOUBLE)
BEGIN
	SELECT MIN(salary) INTO ms
	FROM employees;
END $
DELIMITER ;

CALL show_min_salary(@ms);
SELECT @ms;

#类型三：带IN
#创建存储过程show_someone_salary()，查看“emps”表的某个员工的薪资，并用IN参数empname输入员工姓名。
DELIMITER $
CREATE PROCEDURE show_someone_salary(IN empname VARCHAR(20))
BEGIN 
	SELECT salary FROM employees
	WHERE last_name = empname;
END $
DELIMITER ;

CALL show_someone_salary('Abel');

#类型四：带IN、OUT
#创建存储过程show_someone_salary2()，查看“emps”表的某个员工的薪资，并用IN参数empname
#输入员工姓名，用OUT参数empsalary输出员工薪资。
DELIMITER $
CREATE PROCEDURE show_someone_salary2(IN empname VARCHAR(20),OUT empsalary DOUBLE)
BEGIN
	SELECT salary INTO empsalary
	FROM employees
	WHERE last_name = empname;
END $
DELIMITER ;

SET @empname = 'Abel';
CALL show_someone_salary2(@empname,@empsalary);
SELECT @empsalary;

#类型五：带 INOUT
#创建存储过程show_mgr_name()，查询某个员工领导的姓名，
#并用INOUT参数“empname”输入员工姓名，输出领导的姓名。
DESC employees;

DELIMITER $
CREATE PROCEDURE show_mgr_name(INOUT empname VARCHAR(25))
BEGIN
	SELECT last_name INTO empname
	FROM employees
	WHERE employee_id = (
				SELECT manager_id
				FROM employees
				WHERE last_name = empname
			     );
END $
DELIMITER ;

SET @empname = 'Abel';
CALL show_mgr_name(@empname);

SELECT @empname;

#存储函数
#1.创建存储函数，名称为email_by_name()，参数定义为空，该函数查询Abel的email，并返回，数据类型为字符串型。
DELIMITER $
CREATE FUNCTION email_by_name()
RETURNS VARCHAR(25)
	DETERMINISTIC
	CONTAINS SQL
	READS SQL DATA
BEGIN 
	RETURN (
	SELECT email
	FROM employees
	WHERE last_name = 'Abel');
END $
DELIMITER ;

SELECT email_by_name();

#2.创建存储函数，名称为email_by_id()，参数传入emp_id，
#该函数查询emp_id的email，并返回，数据类型为字符串型。

#创建函数前执行此语句SET GLOBAL log_bin_trust_function_creators = 1;
#可不用创建函数特征
DELIMITER $
CREATE FUNCTION email_by_id(emp_id INT)
RETURNS VARCHAR(25)
	DETERMINISTIC 
	CONTAINS SQL
	READS SQL DATA 
BEGIN 
	RETURN (
	SELECT email
	FROM employees
	WHERE employee_id = emp_id
		);
END $
DELIMITER ;

SELECT email_by_id(102);

#3.创建存储函数count_by_id()，参数传入dept_id，
#该函数查询dept_id部门的员工人数，并返回，数据类型为整型。
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $
CREATE FUNCTION count_by_id(dept_id INT)
RETURNS INT
BEGIN 
	RETURN(
	SELECT COUNT(*)
	FROM employees
	WHERE department_id = dept_id
		);
END $
DELIMITER ;

SET @dept_id = 50;

SELECT count_by_id(@dept_id);	

#存储过程与存储函数的查看
#第一种
SHOW CREATE PROCEDURE show_min_salary;#存储过程
SHOW CREATE FUNCTION count_by_id;#存储函数

#第二种
SHOW PROCEDURE STATUS LIKE 'show_min_salary';

#第三种
SELECT * FROM information_schema.Routines
WHERE ROUTINE_NAME='count_by_id'; 

#存储过程与存储函数的修改
ALTER PROCEDURE show_min_salary
SQL SECURITY INVOKER 
COMMIT '查询工资';

#存储过程与存储函数的删除
DROP PROCEDURE  IF EXISTS show_min_salary;

