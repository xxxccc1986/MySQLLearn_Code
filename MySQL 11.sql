#约束
USE atguigudb;
SELECT * FROM information_schema.table_constraints
WHERE table_name = 'table1';

#非空约束
CREATE DATABASE IF NOT EXISTS dbtest CHARACTER SET 'utf8';
USE dbtest;

#建立表的时候添加约束
CREATE TABLE IF NOT EXISTS table1(
id INT NOT NULL,
last_name VARCHAR(25) NOT NULL,
email VARCHAR(25),
salary DECIMAL(10,2)

);
DESC table1;

SELECT * FROM table1;
INSERT INTO table1(id,last_name,email,salary)
VALUES (1,'tom','',1200.15);


INSERT INTO table1(id,last_name,email,salary)
VALUES (1,NULL,'',1200.15);

UPDATE table1
SET id = 2
WHERE last_name = 'tom';

#建表后通过MODIFY + 列级约束的方式 增加约束
ALTER TABLE table1
MODIFY email VARCHAR(25) NOT NULL;

#建表后通过MODIFY + 列级约束的方式 删除约束条件
ALTER TABLE table1
MODIFY email VARCHAR(25) NULL;

DELETE FROM table1
WHERE id = 1;

#唯一性约束
CREATE TABLE table2(
id INT UNIQUE,#列级约束
last_name VARCHAR(15),
email VARCHAR(15),
salary DECIMAL(10,2),

#表级约束
CONSTRAINT uni_table2_email UNIQUE(email)
);

SELECT * FROM table2;
DESC table2;
SELECT * FROM information_schema.table_constraints
WHERE table_name = 'table2';

INSERT INTO table2(id,last_name,email,salary)
VALUES (1,'tom','14555@qq.com',1250.12);

#建表后通过ADD + 表级约束的方式 增加约束
ALTER TABLE table2
ADD CONSTRAINT uni_table2_sal UNIQUE(salary);

#建表后通过MODIFY + 列级约束的方式 增加约束
ALTER TABLE table2
MODIFY last_name VARCHAR(25) UNIQUE;

#复合的唯一性约束
CREATE TABLE USER(
id INT,
last_name VARCHAR(25),
PASSWORD VARCHAR(25),

#表级约束
CONSTRAINT uni_table2_user_name UNIQUE(id,last_name)
# 
);

DESC table2;

INSERT INTO USER(id,last_name)
VALUES (1,'tom1');

SELECT * FROM USER;


#删除唯一性约束
SHOW INDEX FROM table2;

ALTER TABLE table2
DROP INDEX uni_table2_sal;

ALTER TABLE table2
DROP INDEX last_name;

#主键约束
CREATE TABLE table3(
#id int primary key,#列级约束
id INT,
last_name VARCHAR(25),
salary DECIMAL(10,2),
email VARCHAR(15),

#表级约束
CONSTRAINT PRIMARY KEY(id)
);

#primary key主键不需要起名，其名字永远都是primary
SELECT * FROM information_schema.table_constraints
WHERE table_name = 'table3';

SELECT * FROM table3;

INSERT INTO table3(id,last_name,salary,email)
VALUES (1,'jack',2000,'jkwaw@gmail.com');

#复合主键约束
CREATE TABLE test(
id INT,
NAME VARCHAR(10),
PASSWORD VARCHAR(20),

CONSTRAINT PRIMARY KEY(NAME,PASSWORD)
);

INSERT INTO test(id,NAME,PASSWORD)
VALUES (1,'jack','abc123');

#多列组合的复合主键约束，其中任何列的值都不允许为null，且不能完全一致和重复
INSERT INTO test(id,NAME,PASSWORD)
VALUES (1,NULL,'abc123');#不可行

SELECT * FROM test;

#在ALTER TABLE中添加主键约束
CREATE TABLE test1(
#id int primary key,#列级约束
id INT,
last_name VARCHAR(25),
salary DECIMAL(10,2),
email VARCHAR(15)

#表级约束
#CONSTRAINT PRIMARY KEY(id)
);

DESC test1;

#使用MODIFY + 列级约束在CREATE TABLE 之后添加主键约束
ALTER TABLE test1
MODIFY id INT PRIMARY KEY;

#使用ADD + 表级约束在CREATE TABLE 之后添加主键约束
ALTER TABLE test1
ADD CONSTRAINT PRIMARY KEY (id);

#删除主键约束(不建议删除，破坏了数据的特征)
ALTER TABLE test1
DROP PRIMARY KEY;

#自增列 auto_increment
#创建表时添加自增列
CREATE TABLE test2(
id INT PRIMARY KEY AUTO_INCREMENT,
last_name VARCHAR(15)
);

#在一般情况下，一旦主键字段上添加了auto_increment，
#则在添加数据时，不建议给主键对应的字段赋值
INSERT INTO test2(last_name)
VALUES ('marry');

DESC test2;

SELECT * FROM test2;

#在建表后添加
CREATE TABLE test3(
id INT PRIMARY KEY,
last_name VARCHAR(15)
);

#①使用MODIFY + 列级约束在CREATE TABLE 之后添加自增列
ALTER TABLE test3
MODIFY id INT AUTO_INCREMENT;

#删除自增列
ALTER TABLE test3
MODIFY id INT;

#自增列的值在8.0中不会随着数据库的重启而变化，在5.7中则在重启后按现有存在的最后的一个值自增
INSERT INTO test3
VALUES(0);

#外键约束
#在建表时添加外键约束
#①先创建主表
CREATE TABLE dept(
dept_id INT ,
dept_name VARCHAR(15)
);

#②再创建从表
CREATE TABLE emp(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT,

#表级约束
CONSTRAINT fk_emp1_dept_id FOREIGN KEY (department_id) REFERENCES dept(dept_id)
);

ALTER TABLE dept
MODIFY dept_id INT PRIMARY KEY; 


ALTER TABLE dept
ADD CONSTRAINT PRIMARY KEY(dept_id);

DESC emp;

#外键约束添加数据
#在主表中添加部门id，主表中id不存在，从表添加数据会失败
INSERT INTO dept
VALUES(10,'Test');

SELECT * FROM emp;

#如果主表中的department_id不存在则会添加失败
INSERT INTO emp
VALUES(1,'张三',10);

#在试图删除主表的数据之前，需要解除从表对主表主键的引用，否则删除失败
DELETE FROM dept
WHERE dept_id = 10;

#在试图更新主表的数据之前，需要解除从表对主表主键的引用，否则删除失败
UPDATE dept
SET dept_id = 11
WHERE dept_id = 10;


CREATE TABLE emp1(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT
);

SHOW INDEX FROM emp1;

#在建表后通过使用ADD + 表级约束在CREATE TABLE 之后添加外键约束
ALTER TABLE emp1
ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY(department_id) REFERENCES dept(dept_id);

#约束等级 cascase同步删除 restrict设置为null

#删除外键约束  
#同个表中可以声明多个外键约束
ALTER TABLE emp1
DROP FOREIGN KEY fk_emp_dept_id;

#删除外键约束对应的普通索引
ALTER TABLE emp1
DROP INDEX fk_emp_dept_id;

#检查约束
#MySQL5.7不支持check约束，而在8.0才支持
CREATE TABLE test(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2) CHECK(salary > 2000)
);

INSERT INTO test
VALUES (1,'jack',2500);


#默认值约束
CREATE TABLE test1(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2) DEFAULT 2000
);

INSERT INTO test1(id,last_name)
VALUES (1,'jack');

SELECT * FROM test1;

#在建表后添加使用MODIFY + 列级约束在CREATE TABLE 之后添加自增列
ALTER TABLE test1
MODIFY salary DECIMAL(10,2) DEFAULT 2500;

#删除约束
ALTER TABLE test1
MODIFY salary DECIMAL(10,2);

