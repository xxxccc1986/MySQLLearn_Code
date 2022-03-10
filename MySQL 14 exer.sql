CREATE DATABASE test16_var_cur;
USE test16_var_cur;
CREATE TABLE emp
AS
SELECT * FROM atguigudb.`employees`;
CREATE TABLE dept
AS
SELECT * FROM atguigudb.`departments`;

#无参有返回
#1. 创建函数get_count(),返回公司的员工个数
DELIMITER $
CREATE FUNCTION get_count()	
RETURNS INT
	DETERMINISTIC
	CONTAINS SQL
	READS SQL DATA
BEGIN 
	RETURN (
		SELECT COUNT(*) FROM emp
		);
END $

DELIMITER ;

SELECT get_count();

#有参有返回
#2. 创建函数ename_salary(),根据员工姓名，返回它的工资

DELIMITER $
CREATE FUNCTION ename_salary(emp_name VARCHAR(25))
RETURNS DOUBLE
	DETERMINISTIC
	CONTAINS SQL
	READS SQL DATA
BEGIN 
		
	RETURN(
		SELECT salary FROM emp 
		WHERE last_name = emp_name
		);
		
END $

delimiter ;

select ename_salary('Abel');


#3. 创建函数dept_sal() ,根据部门名，返回该部门的平均工资
delimiter $
create function dept_sal(d_name varchar(30))
returns varchar(30)
	deterministic 
	contains sql
	reads sql data
begin
	return(
		select avg(salary) 
		from dept d join emp e 
		on d.department_id = e.department_id
		where d.department_name = d_name
		);
end $

delimiter ;

select dept_sal('Administration');

#4. 创建函数add_float()，实现传入两个float，返回二者之和
delimiter $
create function add_float(f1 float,f2 float)
returns float
	deterministic 
	contains sql
	reads sql data 
begin 	
	declare sum_info float;
	
	set sum_info = f1 + f2;
	
	return sum_info;
	
end $

delimiter ;

select add_float(1.2,2.3);

#1. 创建函数test_if_case()，实现传入成绩，如果成绩>90,返回A，如果成绩>80,返回B，如果成绩>60,返回C，否则返回D
#要求：分别使用if结构和case结构实现
delimiter $
create function test_if_case(score int)
returns char
	deterministic
	contains sql
	reads sql data
begin 
	DECLARE ch CHAR;
	
	IF score > 90
	THEN set ch = 'A';
	ELSEIF score > 80
	THEN SET ch = 'B';
	ELSEIF score > 60
	THEN SET ch = 'C';
	ELSE SET ch = 'D';
	END IF;
	return ch;
	
end $

delimiter ;

select test_if_case(50);

#方式二
DELIMITER $
CREATE FUNCTION test_if_case(score INT)
RETURNS CHAR
	DETERMINISTIC
	CONTAINS SQL
	READS SQL DATA
BEGIN 
	DECLARE ch CHAR;
	
	case 
	when score > 90
	THEN SET ch = 'A';
	
	when score > 80
	THEN SET ch = 'B';
	
	WHEN score > 60
	THEN SET ch = 'C';
	
	ELSE SET ch = 'D';
	END case;
	
	RETURN ch;
	
END $

DELIMITER ;

#2. 创建存储过程test_if_pro()，传入工资值，如果工资值<3000,则删除工资为此值的员工，
#如果3000 <= 工资值 <= 5000,则修改此工资值的员工薪资涨1000，否则涨工资500
delimiter $
create procedure test_if_pro(in sal double)
begin 
	
	if sal < 3000
	then DELETE FROM emp WHERE salary = sal;
	
	elseif sal <= 5000 and sal >= 3000
	then update emp 
	set salary = salary + 100 
	WHERE salary = sal;
	
	else UPDATE emp 
	set salary = salary + 500 
	WHERE salary = sal;
	end if;
end $

delimiter ;

call test_if_pro(2900);

select * from emp where employee_id = 116;

#创建存储过程insert_data(),传入参数为 IN 的 INT 类型变量 insert_count,实现向admin表中批量插
#入insert_count条记录

CREATE TABLE admin(
id INT PRIMARY KEY AUTO_INCREMENT,
user_name VARCHAR(25) NOT NULL,
user_pwd VARCHAR(35) NOT NULL
);
SELECT * FROM admin;

delimiter $
create procedure insert_data(in insert_count int)
begin 
	declare n int default 0;
	while n <= insert_count do 
	insert into admin(user_name,user_pwd)
	values ('jack','abc123');
	set n = n + 1;
	end while;
end $

delimiter;

call insert_data(5);

#-创建存储过程update_salary()，参数1为 IN 的INT型变量dept_id，表示部门id；参数2为 IN的INT型变量
#change_sal_count，表示要调整薪资的员工个数。查询指定id部门的员工信息，按照salary升序排列，根
#据hire_date的情况，调整前change_sal_count个员工的薪资，详情如下。
delimiter $
create procedure update_salary(in dept_id int,in change_sal_count int)
begin
	declare cout_num int default 1;
	DECLARE e_id INT;
	declare work_year date;
	
	
	#声明游标
	DECLARE emp_cursor CURSOR FOR SELECT employee_id,hire_date 
	FROM emp WHERE department_id = dept_id
	ORDER BY salary ASC;
	
	
	
	#打开游标
	open emp_cursor;
	
	#使用游标
	
	while cout_num <= change_sal_count do
	
	FETCH emp_cursor INTO e_id,work_year; 
	
		if year(work_year) < 1995
		then update emp
		set salary = salary * 1.2
		where employee_id = e_id;
		
		elseif YEAR(work_year) <= 1998 and YEAR(work_year) >= 1995
		then UPDATE emp
		SET salary = salary * 1.15
		WHERE employee_id = e_id;
		
		elseif YEAR(work_year) <= 2001 AND YEAR(work_year) > 1998
		then  UPDATE emp
		SET salary = salary * 1.10
		WHERE employee_id = e_id;
		
		else  UPDATE emp
		SET salary = salary * 1.05
		WHERE employee_id = e_id;
		end if;
		
		set cout_num = cout_num + 1;
	end while;
		
	#关闭游标
	close emp_cursor;
end $

delimiter ;

call update_salary(60,3);

select * from emp where department_id = 60
order by salary asc;

#触发器
CREATE TABLE emps
AS
SELECT employee_id,last_name,salary
FROM atguigudb.`employees`;

select * from emps;

#1. 复制一张emps表的空表emps_back，只有表结构，不包含任何数据
create table emps_back
as 
select * from emps 
where employee_id = 300;

#2. 查询emps_back表中的数据
SELECT * FROM emps_back;

#3. 创建触发器emps_insert_trigger，每当向emps表中添加一条记录时，同步将这条记录添加到emps_back表中
delimiter $
create trigger emps_insert_trigger 
after insert on emps
for each row
begin 
	insert into emps_back(employee_id,last_name,salary)
	values (new.employee_id,new.last_name,new.salary);
end $

delimiter ;
#4. 验证触发器是否起作用

insert into emps
values (290,'jack',2500);

select * from emps;
SELECT * FROM emps_back;

#练习2
#0. 准备工作：使用练习1中的emps表

#1. 复制一张emps表的空表emps_back1，只有表结构，不包含任何数据
CREATE TABLE emps_back1
AS 
SELECT * FROM emps 
WHERE employee_id = 300;

#2. 查询emps_back1表中的数据
select * from  emps_back1;

#3. 创建触发器emps_del_trigger，每当向emps表中删除一条记录时，同步将删除的这条记录添加到emps_back1表中
delimiter $
create trigger emps_del_trigger
after delete on emps
for each row
begin 
	insert into emps_back1(employee_id,last_name,salary)
	values (old.employee_id,old.last_name,old.salary);
	
end $

delimiter ;

#4. 验证触发器是否起作用

delete from emps
where employee_id = 290;

select * from emps where  employee_id = 290;
select * from emps_back1;

