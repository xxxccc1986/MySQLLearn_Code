#排序
SELECT * FROM employees;
# 按照salary 从高到低显示员工的名字和收入
SELECT last_name,salary
FROM employees
ORDER BY salary DESC;

#按照salary 从低到高显示员工的名字和收入
SELECT last_name,salary
FROM employees
ORDER BY salary ASC;#一般在 ORDER BY 字段 后面没有显示的声明使用哪种排序方式，则默认使用的是升序排列


#二级排序
#按照department_id从高到低排序，再按salary 显示员工的名字和收入
SELECT department_id,salary,last_name
FROM employees
ORDER BY department_id DESC,salary ASC;

#分页
#每页显示20条记录，此时显示第一页
SELECT employee_id,last_name
FROM employees
LIMIT 0,20;

#LIMIT
 
#LIMIT 10 == LIMIT 0,10
#在107条数据中，如何只显示第50，51条数据
SELECT department_id,salary,last_name
FROM employees
LIMIT 49,2;

#练习 ：查询展示员工表中工资最高的员工信息
SELECT last_name,salary
FROM employees
ORDER BY salary DESC
LIMIT 1;

#相关练习1
#1.查询员工的姓名和部门号和年薪，按年薪降序,按姓名升序显示
SELECT last_name,department_id,salary * (1 + IFNULL(commission_pct,0)) * 12 "年薪"
FROM employees
ORDER BY "年薪" DESC,last_name ASC;

#相关练习2
#2.选择工资不在 8000 到 17000 的员工的姓名和工资，按工资降序，显示第21到40位置的数据
SELECT last_name,salary
FROM employees
WHERE salary NOT BETWEEN 8000 AND 17000
ORDER BY salary DESC
LIMIT 20,20;

#相关练习3
#3.查询邮箱中包含 e 的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT last_name,salary,email,department_id
FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC,department_id ASC;
