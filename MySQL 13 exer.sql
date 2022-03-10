#练习1
CREATE DATABASE test15_pro_func;
USE test15_pro_func;

#1. 创建存储过程insert_user(),实现传入用户名和密码，插入到admin表中
CREATE TABLE admin(
id INT PRIMARY KEY AUTO_INCREMENT,
user_name VARCHAR(15) NOT NULL,
pwd VARCHAR(25) NOT NULL
);

#2. 创建存储过程get_phone(),实现传入女神编号，返回女神姓名和女神电话
CREATE TABLE beauty(
id INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(15) NOT NULL,
phone VARCHAR(15) UNIQUE,
birth DATE
);
INSERT INTO beauty(NAME,phone,birth)
VALUES
('朱茵','13201233453','1982-02-12'),
('孙燕姿','13501233653','1980-12-09'),
('田馥甄','13651238755','1983-08-21'),
('邓紫棋','17843283452','1991-11-12'),
('刘若英','18635575464','1989-05-18'),
('杨超越','13761238755','1994-05-11');

SELECT * FROM beauty;

DESC beauty;

#3. 创建存储过程date_diff()，实现传入两个女神生日，返回日期间隔大小
DELIMITER $
CREATE PROCEDURE date_diff(IN birth1 DATE,IN birth2 DATE,OUT deff INT)
BEGIN
	SELECT DATEDIFF(birth1,birth2) INTO deff;
END $

DELIMITER ;

SET @birth1 = '1982-02-12';
SET @birth2 = '1980-12-09';
CALL date_diff(@birth1,@birth2,@deff);

SELECT @deff;

#4. 创建存储过程format_date(),实现传入一个日期，格式化成xx年xx月xx日并返回
DELIMITER $
CREATE PROCEDURE format_date(IN date1 DATE,OUT date2 VARCHAR(25))
BEGIN
	SELECT DATE_FORMAT(date1,'%y年%m月%d日') INTO date2;
END $

DELIMITER ;

#set 
SET @date1 = '1982-02-12';
CALL format_date(@date1,@date2);
SELECT @date2;

#5. 创建存储过程beauty_limit()，根据传入的起始索引和条目数，查询女神表的记录

DELIMITER $
CREATE PROCEDURE beauty_limit(IN uid INT,IN size INT)
BEGIN 
	SELECT * 
	FROM  beauty
	LIMIT uid,size;
END $
DELIMITER ;

SET @uid = 1;
SET @size = 3;
CALL beauty_limit(@uid,@size);


#创建带inout模式参数的存储过程
#6. 传入a和b两个值，最终a和b都翻倍并返回
DELIMITER $
CREATE PROCEDURE get_double(INOUT a INT,INOUT b INT)
BEGIN 
	SET a = a * 2 ;
	SET b = b * 2 ;
END $
DELIMITER;

SET @a = 2;
SET @b = 3;
CALL get_double(@a,@b);

SELECT @a,@b;

#7. 删除题目5的存储过程
DROP PROCEDURE IF EXISTS beauty_limit;

#8. 查看题目6中存储过程的信息
SHOW CREATE PROCEDURE get_double;


#练习2
USE test15_pro_func;

CREATE TABLE employees
AS
SELECT * FROM atguigudb.`employees`;

CREATE TABLE departments
AS
SELECT * FROM atguigudb.`departments`;

#无参有返回
#1. 创建函数get_count(),返回公司的员工个数
DELIMITER $
CREATE FUNCTION get_count()
RETURNS INT

BEGIN
	RETURN(
	SELECT COUNT(employee_id)
	FROM employees
		);
END $
DELIMITER ;

SELECT get_count();

DESC employees;

#有参有返回
#2. 创建函数ename_salary(),根据员工姓名，返回它的工资
DELIMITER $
CREATE FUNCTION ename_salary(emp_name VARCHAR(25))
RETURNS DOUBLE(8,2)
BEGIN 
	RETURN(
		SELECT salary 
		FROM employess
		WHERE last_name = emp_name
		);
END $

DELIMITER ;

SELECT ename_salary('Abel');


#3. 创建函数dept_sal() ,根据部门名，返回该部门的平均工资
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $
CREATE FUNCTION dept_sal(dep_name VARCHAR(25))
RETURNS DOUBLE(8,2)
BEGIN 
	RETURN(
		SELECT AVG(salary )
		FROM departments d JOIN employees e
		ON d.depatrment_id = e.department_id
		WHERE department_name = dep_name
		);
END $
DELIMITER ;

#SET @dep_name= 'Abel';

SELECT ename_salary('Marketing');


#4. 创建函数add_float()，实现传入两个float，返回二者之和
DELIMITER $
CREATE FUNCTION add_float(folat1 FLOAT,folat2 FLOAT)
RETURNS FLOAT
BEGIN 
	RETURN(
	SELECT float1 + float2 
		);
	
END $
DELIMITER ;

SET @float1 = 12.2;
SET @float2 = 1.2;

SELECT add_float(@float1,@float2);

