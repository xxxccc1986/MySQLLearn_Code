SELECT * FROM employees;

SELECT employee_id emp_id,last_name AS lname,department_id "部门id"
FROM employees;

# 未去重的情况
SELECT department_id 
FROM employees;

# 去重的情况
SELECT DISTINCT department_id,salary 
FROM employees;

#空值参与运算
SELECT employee_id,salary "月工资",salary * (1 + IFNULL(commission_pct,0)) * 12 "年工资"
FROM employees;

#着重号 `
SELECT * FROM `order`;

#查询常数
SELECT '北京市',employee_id,salary
FROM employees;

#显示表的结构
DESCRIBE employees;

#查询50号部门的员工信息
#过滤条件
SELECT * FROM employees
WHERE department_id = 90;

SELECT * FROM employees
WHERE last_name = 'King';

#相关练习题1
#1.查询员工12个月的工资总和，并起别名为ANNUAL SALARY
SELECT employee_id "员工id",salary * (1 + IFNULL(commission_pct,0)) * 12 "ANNUAL SALARY"
FROM employees;

#相关练习题2
#2.查询employees表中去除重复的job_id以后的数据
SELECT DISTINCT job_id 
FROM employees;

#相关练习题3
#3.查询工资大于12000的员工姓名和工资
SELECT first_name,last_name,salary
FROM employees
WHERE salary > 12000;

#相关练习题4
#4.查询员工号为176的员工的姓名和部门号
SELECT first_name,last_name,department_id 
FROM employees
WHERE employee_id = 176;

#相关练习题5
#5.显示表 departments 的结构，并查询其中的全部数据
DESCRIBE departments;
SELECT * FROM departments;
