#变量
#全局系统变量
SHOW GLOBAL VARIABLES;
#会话系统变量
SHOW SESSION VARIABLES;

#查询部门系统变量
SHOW GLOBAL VARIABLES LIKE 'admin_%';

#用户变量
#1.声明两个变量，求和并打印 （分别使用会话用户变量、局部变量的方式实现）
#局部变量
DELIMITER $
CREATE PROCEDURE get_sum()
BEGIN
	#声明变量
	DECLARE a,b,c INT DEFAULT 0;
	
	#变量赋值
	SET a = 1;
	SET b = 2;
	SET c = a + b;
	
	#查询变量的值
	SELECT c;
	

END $
DELIMITER ;

CALL get_sum();


#会话用户变量
SET @a = 1;
SET @b = 2;
SET @c = @a + @b;
SELECT @c;


#2.创建存储过程“different_salary”查询某员工和他领导的薪资差距，并用IN参数emp_id接收员工
#id，用OUT参数dif_salary输出薪资差距结果。
CREATE DATABASE IF NOT EXISTS mydb;

USE mydb;

CREATE TABLE emp
AS
SELECT * FROM atguigudb.`employees`;

SELECT * FROM emp;

DELIMITER $
CREATE PROCEDURE different_salary(IN emp_id INT,OUT diff_salary DOUBLE)
BEGIN
	#变量的定义
	DECLARE emp_sal  DOUBLE DEFAULT 0.0;
	DECLARE mgr_sal  DOUBLE DEFAULT 0.0;
	
	
	#变量的赋值
	SELECT salary INTO emp_sal FROM emp WHERE employee_id = emp_id;
	
	
	SELECT salary INTO mgr_sal FROM emp WHERE employee_id = (
								SELECT manager_id 
								FROM emp 
								WHERE employee_id = emp_id
							         );
	SET diff_salary = mgr_sal - emp_sal;
	
END $

DELIMITER ;

SET @emp_id = 102;

CALL different_salary(@emp_id,@diff_salary);

SELECT @diff_salary;

#定义条件与处理程序
#定义"ERROR 1148(42000)"错误，名称为command_not_allowed。
DECLARE command_not_allowed CONDITION FOR 1148;

DECLARE command_not_allowed CONDITION FOR SQLSTATE '42000';

#处理程序
 #方法1：捕获sqlstate_value
DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @info = 'NO_SUCH_TABLE';
#方法2：捕获mysql_error_value
DECLARE CONTINUE HANDLER FOR 1146 SET @info = 'NO_SUCH_TABLE';
#方法3：先定义条件，再调用
DECLARE no_such_table CONDITION FOR 1146;
DECLARE CONTINUE HANDLER FOR NO_SUCH_TABLE SET @info = 'NO_SUCH_TABLE';
#方法4：使用SQLWARNING
DECLARE EXIT HANDLER FOR SQLWARNING SET @info = 'ERROR';
#方法5：使用NOT FOUND
DECLARE EXIT HANDLER FOR NOT FOUND SET @info = 'NO_SUCH_TABLE';
#方法6：使用SQLEXCEPTION
DECLARE EXIT HANDLER FOR SQLEXCEPTION SET @info = 'ERROR';

#流程控制
#if
#声明存储过程“update_salary_by_eid1”，定义IN参数emp_id，输入员工编号。判断该员工
#薪资如果低于8000元并且入职时间超过5年，就涨薪500元；否则就不变。

SELECT * FROM emp;

DELIMITER $
CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
BEGIN	
	#声明局部变量	
	DECLARE sal DOUBLE DEFAULT 0.0;
	DECLARE work_year DOUBLE DEFAULT 0.0;
	
	SELECT salary INTO sal FROM emp WHERE employee_id = emp_id;
	SELECT DATEDIFF(CURDATE(),hire_date) / 365 INTO work_year 
	FROM emp WHERE employee_id = emp_id;
	
	IF 
	sal < 8000 AND work_year >= 5
	THEN UPDATE emp
	SET salary = salary + 500 
	WHERE employee_id = emp_id;
	END IF;
	
	
END $

DELIMITER ;

CALL update_salary_by_eid1(104);



#声明存储过程“update_salary_by_eid2”，定义IN参数emp_id，输入员工编号。判断该员工
#薪资如果低于9000元并且入职时间超过5年，就涨薪500元；否则就涨薪100元。
DELIMITER $
CREATE PROCEDURE pdate_salary_by_eid2(IN emp_id INT)
BEGIN	
	#声明局部变量	
	DECLARE sal DOUBLE DEFAULT 0.0;
	DECLARE work_year DOUBLE DEFAULT 0.0;
	
	SELECT salary INTO sal FROM emp WHERE employee_id = emp_id;
	SELECT DATEDIFF(CURDATE(),hire_date) / 365 INTO work_year 
	FROM emp WHERE employee_id = emp_id;
	
	IF 
	sal < 9000 AND work_year >= 5
	THEN UPDATE emp
	SET salary = salary + 500 
	WHERE employee_id = emp_id;
	ELSE UPDATE emp
	SET salary = salary + 100
	WHERE employee_id = emp_id;
	END IF;
	
	
END $

DELIMITER ;

CALL pdate_salary_by_eid2(103);
CALL pdate_salary_by_eid2(104);

SELECT * FROM emp WHERE employee_id = 103;
SELECT * FROM emp WHERE employee_id = 104;

#声明存储过程“update_salary_by_eid3”，定义IN参数emp_id，输入员工编号。判断该员工
#薪资如果低于9000元，就更新薪资为9000元；薪资如果大于等于9000元且低于10000的，但是奖金
#比例为NULL的，就更新奖金比例为0.01；其他的涨薪100元
DELIMITER $
CREATE PROCEDURE update_salary_by_eid3(IN emp_id INT)
BEGIN	
	#声明局部变量	
	DECLARE sal DOUBLE DEFAULT 0.0;
	DECLARE bonus DOUBLE DEFAULT 0.0;
	
	SELECT salary INTO sal FROM emp WHERE employee_id = emp_id;
	SELECT commission_pct INTO bonus 
	FROM emp WHERE employee_id = emp_id;
	
	IF 
	sal < 9000 THEN UPDATE emp
	SET salary = 9000
	WHERE employee_id = emp_id;
	ELSEIF sal <10000 AND sal >= 9000 AND bonus IS NULL
	THEN UPDATE emp
	SET commission_pct = 0.01
	WHERE employee_id = emp_id;
	ELSE UPDATE emp
	SET salary = salary + 100
	WHERE employee_id = emp_id;	
	END IF;
	
	
END $

DELIMITER ;

CALL update_salary_by_eid3(104);

SELECT * FROM emp WHERE employee_id = 104;
SELECT * FROM emp WHERE employee_id = 103;
SELECT * FROM emp WHERE employee_id = 102;

#CASE结构
#声明存储过程“update_salary_by_eid4”，定义IN参数emp_id，输入员工编号。判断该员工
#薪资如果低于9000元，就更新薪资为9000元；薪资大于等于9000元且低于10000的，但是奖金比例
#为NULL的，就更新奖金比例为0.01；其他的涨薪100元。

DELIMITER $
CREATE PROCEDURE update_salary_by_eid4(IN emp_id INT)
BEGIN
	DECLARE sal DOUBLE DEFAULT 0.0;
	DECLARE bonus DOUBLE DEFAULT 0.0;
	
	SELECT salary INTO sal FROM emp WHERE employee_id = emp_id;
	SELECT commission_pct INTO bonus FROM emp WHERE employee_id = emp_id;
	
	CASE 
	WHEN sal < 9000 
	THEN UPDATE emp 
	SET salary  = 9000 
	WHERE employee_id = emp_id;
	
	WHEN sal < 10000 AND bonus IS NULL
	THEN UPDATE emp 
	SET commission_pct  = 0.01
	WHERE employee_id = emp_id;
	
	ELSE UPDATE emp 
	SET salary  = salary + 100
	WHERE employee_id = emp_id;
	END CASE;
	
END $
DELIMITER ;

CALL update_salary_by_eid4(103);

SELECT * FROM emp WHERE employee_id = 103;

#举例4：声明存储过程update_salary_by_eid5，定义IN参数emp_id，输入员工编号。判断该员工的
#入职年限，如果是0年，薪资涨50；如果是1年，薪资涨100；如果是2年，薪资涨200；如果是3年，
#薪资涨300；如果是4年，薪资涨400；其他的涨薪500。
DELIMITER $
CREATE PROCEDURE update_salary_by_eid5(IN emp_id INT)
BEGIN
	DECLARE work_year INT DEFAULT 0.0;
	
	
	SELECT ROUND(DATEDIFF(CURDATE(),hire_date) / 365) INTO work_year 
	FROM emp WHERE employee_id = emp_id;
	
	
	CASE work_year
	WHEN work_year = 0
	THEN UPDATE emp 
	SET salary  = salary + 50
	WHERE employee_id = emp_id;
	
	WHEN work_year = 1
	THEN UPDATE emp 
	SET salary  = salary + 100
	WHERE employee_id = emp_id;
	
	WHEN work_year = 2
	THEN UPDATE emp 
	SET salary  = salary + 200
	WHERE employee_id = emp_id;
	
	WHEN work_year = 3
	THEN UPDATE emp 
	SET salary  = salary + 300
	WHERE employee_id = emp_id;
	
	WHEN work_year = 4
	THEN UPDATE emp 
	SET salary  = salary + 400
	WHERE employee_id = emp_id;
	
	ELSE UPDATE emp 
	SET salary  = salary + 500
	WHERE employee_id = emp_id;
	END CASE;
	
END $
DELIMITER ;

CALL update_salary_by_eid5(101);
SELECT * FROM emp WHERE employee_id = 101;

#循环结构
#loop结构
#当市场环境变好时，公司为了奖励大家，决定给大家涨工资。
#声明存储过程“update_salary_loop()”，声明OUT参数num，输出循环次数。
#存储过程中实现循环给大家涨薪，薪资涨为原来的1.1倍。
#直到全公司的平均薪资达到12000结束。并统计循环次数。
DELIMITER $
CREATE PROCEDURE update_salary_loop(OUT num INT)
BEGIN
	#定义局部变量 
	DECLARE n INT DEFAULT 0;
	#declare avg_sal double default 0.0;
	
	#
	
	loop_label:LOOP
	   IF (SELECT AVG(salary) FROM emp) >= 12000  
		THEN LEAVE loop_label;
	   END IF;
	    
	   UPDATE emp SET salary = salary * 1.1;  
	    
	   SET n = n + 1;
	    
	   END LOOP loop_label;
	   
	   SET num = n;
	
END $

DELIMITER ;

CALL update_salary_loop(@num);
SELECT @num;

#WHILE结构
#市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。
#声明存储过程“update_salary_while()”，声明OUT参数num，输出循环次数。
#存储过程中实现循环给大家降薪，薪资降
#为原来的90%。直到全公司的平均薪资达到5000结束。并统计循环次数。
DELIMITER $
CREATE PROCEDURE leave_while(OUT num INT)
BEGIN 
	DECLARE n INT DEFAULT 0;
	
	while_label:WHILE 
	
	 (SELECT AVG(salary) FROM emp )  > 5000 
	 	
	DO UPDATE emp SET salary = salary * 0.9;
		
	SET n = n + 1;
		
	END WHILE while_label;
	
	SET num = n;
END $

DELIMITER ;

CALL leave_while(@num);
SELECT @num;

SELECT AVG(salary) FROM emp;

#REPEAT 结构
#当市场环境变好时，公司为了奖励大家，决定给大家涨工资。
#声明存储过程“update_salary_repeat()”，声明OUT参数num，输出循环次数。
#存储过程中实现循环给大家涨薪，薪资涨为原来的1.15倍。
#直到全公司的平均薪资达到13000结束。并统计循环次数。
DELIMITER $
CREATE PROCEDURE update_salary_repeat(OUT num INT)
BEGIN 

	DECLARE cout INT DEFAULT 0;
	
	repeat_label:REPEAT 
		UPDATE emp SET salary = salary * 1.15;
		SET cout = cout + 1;
	UNTIL (SELECT AVG(salary) FROM emp) >= 13000
	END REPEAT repeat_label;
	
	SET num = cout;
	
		
END $

DELIMITER ;

CALL update_salary_repeat(@num);
SELECT @num;

SELECT AVG(salary) FROM emp;

#LEAVE语句
#：创建存储过程 “leave_begin()”，声明INT类型的IN参数num。给BEGIN...END加标记名，并在
#BEGIN...END中使用IF语句判断num参数的值。
#如果num<=0，则使用LEAVE语句退出BEGIN...END；
#如果num=1，则查询“employees”表的平均薪资；
#如果num=2，则查询“employees”表的最低薪资；
#如果num>2，则查询“employees”表的最高薪资。
#IF语句结束后查询“employees”表的总人数。

DELIMITER $
CREATE PROCEDURE leave_begin(IN num INT)
if_label:BEGIN	
	IF 
	num <= 0
	THEN LEAVE if_label;
	ELSEIF num = 1
	THEN SELECT AVG(salary) FROM emp;
	ELSEIF num = 2
	THEN SELECT MIN(salary) FROM emp;
	ELSEIF num > 2
	THEN SELECT MAX(salary) FROM emp;
	END IF;
	
	SELECT COUNT(employee_id) FROM emp;
END $

DELIMITER ;

CALL leave_begin(3);

#当市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。
#声明存储过程“leave_while()”，声明OUT参数num，输出循环次数，存储过程中使用WHILE循环给大家降低薪资为原来薪资的90%，
#直到全公司的平均薪资小于等于10000，并统计循环次数。
DELIMITER $
CREATE PROCEDURE leave_while(OUT num INT)
BEGIN 
	DECLARE n INT DEFAULT 0;
	
	
	
	while_lab:WHILE TRUE DO
		IF (SELECT AVG(salary) FROM emp) <= 10000 THEN LEAVE while_lab;
		END IF;
		
		UPDATE emp SET salary  = salary * 0.9;
		SET n = n + 1;	
		
	END WHILE while_lab;
	
	SET num = n;
END $

DELIMITER ;

CALL leave_while(@num);

SELECT @num;

SELECT AVG(salary) FROM emp;

#ITERATE的使用
DELIMITER $
CREATE PROCEDURE iterate_test()
BEGIN 
	DECLARE n INT DEFAULT 0;
	
	iterate_lab:LOOP
	
	SET n = n + 1;
	
	IF n < 10
	THEN ITERATE iterate_lab;
	ELSEIF n > 15
	THEN LEAVE iterate_lab;
	END IF; 
	
	SELECT '这是个测试语句';
	
	END LOOP;
	
END $

DELIMITER ;

CALL iterate_test;

#游标的使用
#创建存储过程“get_count_by_limit_total_salary()”，声明IN参数 limit_total_salary，DOUBLE类型；
#声明OUT参数total_count，INT类型。函数的功能可以实现累加薪资最高的几个员工的薪资值，
#直到薪资总和达到limit_total_salary参数的值，返回累加的人数给total_count。

DELIMITER $
CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE,OUT total_count INT)
BEGIN 
	#定义局部变量
	DECLARE n INT DEFAULT 0;#记录累加的次数
	DECLARE emp_sal DOUBLE;#记录某一个员工的工资
	DECLARE sum_sal DOUBLE DEFAULT 0.0;#记录累加的工资总和
	
	#定义游标
	DECLARE emp_cursor CURSOR FOR SELECT salary FROM emp ORDER BY salary DESC;
	
	#打开游标
	OPEN emp_cursor;	
	
	REPEAT 

	#使用游标
	FETCH emp_cursor INTO emp_sal;
	
	SET sum_sal = sum_sal +  emp_sal;
	SET n = n + 1;
	UNTIL sum_sal >= limit_total_salary
	END REPEAT;
	
	SET total_count = n;
	#关闭游标
	CLOSE emp_cursor;
	
	
	
END $

DELIMITER ;

CALL get_count_by_limit_total_salary(200000,@total_count);
SELECT @total_count;


 