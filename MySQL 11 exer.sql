#练习1
CREATE DATABASE IF NOT EXISTS test_04emp CHARACTER SET 'utf8';
USE test_04emp;

SHOW TABLES;

CREATE TABLE emp2(
id INT,
emp_name VARCHAR(15)
);

CREATE TABLE dept2(
id INT,
dept_name VARCHAR(15)
);

#1.向表emp2的id列中添加PRIMARY KEY约束
ALTER TABLE emp2
MODIFY id INT PRIMARY KEY;

DESC emp2;
#2.向表dept2的id列中添加PRIMARY KEY约束
ALTER TABLE dept2
MODIFY id INT PRIMARY KEY;

#3.向表emp2中添加列dept_id，并在其中定义FOREIGN KEY约束，与之相关联的列是dept2表中的id列。
ALTER TABLE emp2
ADD dept_id INT;

ALTER TABLE emp2
ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY dept_id REFERENCES dept2(id);

#练习2
USE test01_library;
DESC books;

#给相应的字段添加约束
ALTER TABLE books
MODIFY id INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE books
MODIFY NAME VARCHAR(25) NOT NULL;

ALTER TABLE books
MODIFY AUTHORS VARCHAR(25) NOT NULL;

ALTER TABLE books
MODIFY price DECIMAL(10,2) NOT NULL;

ALTER TABLE books
MODIFY num INT NOT NULL;

#练习3
#给相应的字段添加约束
DESC offices;
ALTER TABLE offices
ADD PRIMARY KEY(office_code);

ALTER TABLE offices
MODIFY city VARCHAR(50) NOT NULL;

ALTER TABLE offices
MODIFY country VARCHAR(50) NOT NULL;

#employees_info
DESC employees_info;

ALTER TABLE employees_info
MODIFY emp_num INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE employees_info
MODIFY last_name VARCHAR(50) NOT NULL;

ALTER TABLE employees_info
MODIFY first_name VARCHAR(50) NOT NULL;

ALTER TABLE employees_info
MODIFY mobile VARCHAR(25) UNIQUE;

ALTER TABLE employees_info 
MODIFY CODE INT NOT NULL;

ALTER TABLE employees_info
ADD CONSTRAINT fk_emp_info_code FOREIGN KEY CODE REFERENCES offices(office_code);

ALTER TABLE employees_info
MODIFY job_title VARCHAR(50) NOT NULL;

ALTER TABLE employees_info
MODIFY birthday DATETIME NOT NULL;
