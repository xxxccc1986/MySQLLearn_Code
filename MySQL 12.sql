#视图
CREATE DATABASE IF NOT EXISTS testview CHARACTER SET 'utf8';
USE testview;

CREATE TABLE emp
AS 
SELECT * 
FROM atguigudb.`employees`;


CREATE TABLE dept
AS 
SELECT *
FROM atguigudb.`departments`;

#单表视图
SELECT * FROM emp;
CREATE VIEW v_emp
AS 
SELECT employee_id,last_name,email 
FROM emp;

#在不设置别名的情况下默认字段列名为视图字段名称
CREATE VIEW v_emp
AS 
SELECT employee_id,last_name,email 
FROM emp;

SELECT * FROM v_emp3;

#查询语句中的字段别名作为视图的字段名称
CREATE VIEW v_emp2
AS 
SELECT employee_id emp_id,last_name month_sal,email ema
FROM emp;

#表名后面字段列表的个数需要与select语句中的一致
CREATE VIEW v_emp3(emp_id,month_sal,ema)
AS 
SELECT employee_id,last_name,email
FROM emp;

#通过视图查询基表中不存在的字段
CREATE VIEW emp_avg_sal(dep_id,sal)
AS
SELECT department_id,AVG(salary)
FROM emp
GROUP BY department_id;

SELECT * FROM ed_dept;

#多表视图
CREATE VIEW ed_dept
AS
SELECT e.employee_id,d.department_id
FROM emp e JOIN dept d
ON e.department_id = d.department_id;

#利用视图对数据进行格式化
CREATE VIEW ed_info
AS
SELECT CONCAT (e.last_name,'(',d.department_name,')') emp_info
FROM emp e JOIN dept d
ON e.department_id = d.department_id;

#基于视图创建视图
CREATE VIEW t_view 
AS 
SELECT employee_id,last_name
FROM emp;

#查看数据库的视图
#查看数据库的表和视图
SHOW TABLES;

#查看视图的结构
DESCRIBE ed_info;

#查看视图的属性信息
SHOW TABLE STATUS LIKE 'ed_info';

#查看视图的详细定义信息
SHOW CREATE VIEW ed_info;

#增删改视图数据 和 视图的删除
SELECT * FROM v_emp;
SELECT employee_id,last_name,email 
FROM emp;
#一般情况下更新不会失败，
#但是在视图相应修改不在基表中存在字段的数据则会更新失败
#更新视图的数据也会导致基表数据的修改，反之亦然
UPDATE v_emp
SET email = 'sky'
WHERE employee_id = 101;


#修改视图
#方式一
CREATE OR REPLACE VIEW v_emp
AS
SELECT  employee_id,last_name,email,salary
FROM emp
WHERE salary > 7000; 

#方式二
ALTER TABLE v_emp
AS
SELECT employee_id,last_name,email,salary
FROM emp;

SHOW TABLES;

#视图的删除
DROP VIEW IF EXISTS v_emp3;