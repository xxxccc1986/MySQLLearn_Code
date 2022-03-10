#AVG / SUM（只适用于数值类型的字段或变量）
SELECT AVG(salary),SUM(salary)
FROM employees;

#MAX / MIN
SELECT MAX(last_name),MIN(last_name)
FROM employees;

SELECT MAX(hire_date),MIN(hire_date)
FROM employees;


#COUNT
SELECT COUNT(salary),COUNT(1),COUNT(2)
FROM employees;
#以上的聚合函数都是不包括null值的，自动过滤


#GROUP BY的使用
#查询各个部门的平均工资，最高工资
SELECT department_id,AVG(salary),MAX(salary)
FROM employees
GROUP BY department_id;

#查询各个job_id的平均工资
SELECT job_id,AVG(salary)
FROM employees
GROUP BY job_id;

#查询各个department_id,job_id的平均工资
#方式一:
SELECT department_id,job_id,AVG(salary)
FROM employees
GROUP BY  department_id,job_id;
#两种方式的结果都是相同，只是分组的先后顺序有所变化
#方式二：
SELECT job_id,department_id,AVG(salary)
FROM employees
GROUP BY  job_id,department_id;


#Having的使用
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000;

#查询部门id为10，20，30，40这4个部门中最高工资比10000高的部门信息
SELECT department_id,MAX(salary) max_salary
FROM employees
#where department_id in (10,20,30,40)
GROUP BY department_id
HAVING max_salary > 10000 AND department_id IN (10,20,30,40);	

/*
SQL99语法
SELECT ...,...(存在的组函数)
FROM ...,... (LEFT / RIGHT) JOIN ON 表的连接条件
WHERE 不包含组函数的过滤条件
GROUP BY ...
HAVING 包含组函数的过滤条件
ORDER BY ...
LIMIT...

执行顺序 from ... on ...(left / right)join ... where ... group by ... select ... distinct ... order by ... limit ...
*/

#相关练习题
#1.where子句可否使用组函数进行过滤?
#使用组函数需要进行过滤需要先执行GROUP BY 进行 按组分类 而GROUP BY是在where后面执行，不能使用后向引用

#2.查询公司员工工资的最大值，最小值，平均值，总和
SELECT e1.last_name,e1.salary,MAX(e1.salary),e2.last_name,e2.salary,MIN(e1.salary),AVG(e1.salary),SUM(e1.salary)
FROM employees e1,employees e2
WHERE e1.salary;


#3.查询各job_id的员工工资的最大值，最小值，平均值，总和
SELECT job_id,MAX(salary) "最大",MIN(salary) "最小",AVG(salary) "平均",SUM(salary) "总和"
FROM employees
GROUP BY job_id;

#4.选择具有各个job_id的员工人数
SELECT job_id,COUNT(employee_id)
FROM employees
GROUP BY job_id;


# 5.查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT MAX(salary)- MIN(salary) DIFFERENCE 
FROM employees;


# 6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT manager_id,MIN(salary) "最低工资"
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) > 6000;


# 7.查询所有部门的名字，location_id，员工数量和平均工资，并按平均工资降序
SELECT d.department_name,d.location_id,COUNT(e.`employee_id`),AVG(e.salary) 
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
GROUP BY d.department_name,d.location_id
ORDER BY AVG(e.salary) DESC;


# 8.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT e.job_id,d.department_name,MIN(e.salary) "最低工资"
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
GROUP BY e.`job_id`,d.`department_name`
ORDER BY MIN(e.salary) DESC;
