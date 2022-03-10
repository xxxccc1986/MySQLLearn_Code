#创建和管理数据库
#方式一
CREATE DATABASE testdb;
SHOW CREATE DATABASE testdb;

#方式二
CREATE DATABASE testdb1 CHARACTER SET 'GBK';
SHOW CREATE DATABASE testdb1;

#方式三 如果创建的数据库已经存在，则创建失败，但不报错
CREATE DATABASE IF NOT EXISTS testdb1 CHARACTER SET 'GBK';
SHOW CREATE DATABASE testdb;

#管理
#查看数据库
SHOW DATABASES;


#使用数据库
USE atguigudb;

#查看数据库的表
SHOW TABLES;

#查看当前使用的数据库
SELECT DATABASE() FROM DUAL;

#查看指定数据下的表
SHOW TABLES FROM mysql;

#修改数据库
#修改数据库字符集
ALTER DATABASE testdb1 CHARACTER SET 'utf8';

#删库
DROP DATABASE testdb1;

DROP DATABASE IF  EXISTS testdb;

#创建数据表
USE atguigudb;
#方式一
CREATE TABLE IF NOT EXISTS test_tab (
id INT,
test_name VARCHAR(15),#使用VARCHAR来定义字符串时，必须在使用VARCHAR时指明其长度
hire_date DATE
);

#方式二
CREATE TABLE test_table 
AS 
SELECT employee_id,last_name
FROM employees;

SELECT * FROM test_table;
#查询语句中字段的别名可以作为新创建的表的字段名称
#
CREATE TABLE test_t
AS
SELECT e.employee_id id,e.last_name last_n,d.department_name d_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id;


#drop table if  exists test_t;
#创建一个表的employees——copy，实现对employees表的复制，包括表的数据
CREATE TABLE employees_copy 
AS 
SELECT * FROM employees;
SHOW TABLES FROM atguigudb;

SELECT * FROM employees_copy;

#创建一个表的employees_blank，实现对employees表的复制，不包括表的数据
CREATE TABLE employees_blank
AS 
SELECT * FROM employees
WHERE 1 = 2 ;
SELECT * FROM employees_blank;

#2. 修改数据表
DESC test_table;
#①添加字段
ALTER TABLE test_tab
ADD salary DOUBLE(10,2); #默认添加成最后的一个字段

ALTER TABLE test_tab 
ADD phone_num VARCHAR(20) FIRST;

ALTER TABLE test_tab
ADD email VARCHAR(30) AFTER test_name;

#②修改字段：数据类型、长度等等
#数据类型一般不做修改，因为无法保证修改后原数据的是否适用于现在的类型
ALTER TABLE test_tab
MODIFY test_name VARCHAR(25);


#③重命名字段
ALTER TABLE test_tab
CHANGE salary month_salary DOUBLE(10,2);

ALTER TABLE test_tab
CHANGE email my_email VARCHAR(25); #在重命名字段的同时还能够更改长度

#④删除字段
ALTER TABLE test_tab
DROP COLUMN my_email;#删除的是某一列

#3. 重命名数据表
#方式一
RENAME TABLE test_tab
TO test_table;

#方式二
ALTER TABLE test_tab
RENAME TO test_t;

#4. 删除数据表
#将表结构和表的数据一起删除，释放表空间
DROP TABLE IF EXISTS test_t;

#5. 清空数据表
#清空表中的所有数据，但表的结构还保留
TRUNCATE TABLE employees_copy;
SELECT * FROM employees_copy;


