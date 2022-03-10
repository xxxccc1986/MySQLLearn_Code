#多表查询
SELECT emp.employee_id,dep.department_name,emp.department_id
FROM employees emp,departments dep
WHERE emp.employee_id = dep.department_id;

#查询员工的employee_id,last_name,department_name,city
SELECT emp.`employee_id`,emp.`last_name`,dep.`department_name`,loc.`city`
FROM employees emp,departments dep,locations loc
WHERE emp.`department_id` = dep.`department_id` 
AND dep.`location_id` = loc.`location_id`;


#等值连接  与 非等值连接 
SELECT * FROM job_grades;

#非等值连接 
SELECT last_name,salary,grade_level
FROM employees e,job_grades j
WHERE e.`salary` BETWEEN j.`lowest_sal` AND j.`highest_sal`
ORDER BY j.`grade_level` DESC;


#自连接 与 非自连接 
#自连接 查询员工id，员工姓名及其管理者的id和姓名 
SELECT e1.employee_id,e1.last_name,e2.`employee_id`,e2.last_name
FROM employees e1,employees e2
WHERE e1.`manager_id` = e2.`employee_id`;

#内连接   与   外连接
#内连接
SELECT e.employee_id,d.department_name
FROM employees e,departments d
WHERE e.department_id = d.department_id;


#sql99语法实现内连接
SELECT last_name,department_name,city
FROM employees e INNER JOIN departments d#此处的INNER可省略
ON e.`department_id` = d.department_id 
JOIN locations l
ON d.`location_id` = l.`location_id`;

#sql99语法
#多表查询 employees表的员工id对应的departments表的员工的部门名字
#左上图 左外连接
SELECT last_name,department_name
FROM employees e LEFT OUTER JOIN departments d#此处的OUTER可省略
ON e.`department_id` = d.department_id;

#右上图 右外连接
SELECT last_name,department_name
FROM employees e RIGHT OUTER JOIN departments d#此处的OUTER可省略
ON e.`department_id` = d.department_id;

#中间图  内连接
SELECT employee_id,department_name
FROM employees e JOIN departments d
ON e.`department_id` = d.`department_id`;

#满外连接----MySQL不支持FULL
SELECT last_name,department_name
FROM employees e FULL OUTER JOIN departments d#此处的OUTER可省略
ON e.`department_id` = d.department_id;

#左中图
SELECT employee_id,department_name
FROM employees e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE d.`department_id`IS NULL;

#右中图
SELECT employee_id,department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`department_id` IS NULL;

#左下图 满外连接
SELECT employee_id,department_name
FROM employees e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`
UNION ALL
SELECT employee_id,department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`department_id` IS NULL;

#右下图
SELECT employee_id,department_name
FROM employees e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE d.`department_id`IS NULL
UNION ALL
SELECT employee_id,department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`department_id` IS NULL;


#自然连接
SELECT e.`employee_id`,e.`last_name`,d.`department_name`
FROM employees e NATURAL JOIN departments d;

#USING连接
SELECT e.`employee_id`,e.`last_name`,d.`department_name`
FROM employees e  JOIN departments d
USING (department_id);

#相关练习题
#1.显示所有员工的姓名，部门号和部门名称。
SELECT e.last_name,e.department_id,d.department_name
FROM employees  e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`;

#2.查询90号部门员工的job_id和90号部门的location_id
SELECT e.job_id,d.location_id
FROM employees e JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE d.`department_id`= 90;


#3.选择所有有奖金的员工的 last_name , department_name , location_id , city
SELECT e.last_name,d.department_name,d.location_id,l.city
FROM employees e 
LEFT JOIN departments d
ON e.`department_id` = d.`department_id` 
LEFT JOIN locations l
ON d.`location_id` = l.`location_id`
WHERE e.`commission_pct` IS NOT NULL ;

#4.选择city在Toronto工作的员工的 last_name , job_id , department_id , department_name
SELECT e.last_name,e.job_id,d.department_id,d.department_name
FROM employees e 
JOIN departments d
ON e.`department_id` = d.`department_id`
JOIN locations l
ON d.`location_id` = l.`location_id`
WHERE l.`city` = 'Toronto';

#5.查询员工所在的部门名称、部门地址、姓名、工作、工资，其中员工所在部门的部门名称为’Executive’
SELECT d.department_name,l.street_address,e.last_name,e.job_id,e.salary
FROM employees e
JOIN departments d
ON e.`department_id`= d.`department_id`
JOIN locations l 
ON d.`location_id` = l.`location_id`
WHERE department_name = 'Executive';

#6.选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
SELECT e1.emplo yee_id,e1.last_name,e2.employee_id manager,e2.last_name
FROM  employees e1 LEFT JOIN employees e2
ON e1.`manager_id`= e2.`employee_id`;

#7.查询哪些部门没有员工
SELECT d.department_id,e.department_id
FROM departments d 
LEFT JOIN employees e
ON d.`department_id` = e.`department_id`
WHERE e.`department_id` IS NULL;

#8. 查询哪个城市没有部门
SELECT l.city,d.`department_id`
FROM locations l 
LEFT JOIN departments d
ON l.`location_id` = d.`location_id`
WHERE d.`location_id` IS NULL;

# 9. 查询部门名为 Sales 或 IT 的员工信息
SELECT e.`employee_id`,d.`department_name`,e.last_name,e.`salary`
FROM departments d 
JOIN employees e
ON d.`department_id` = e.`department_id`
WHERE d.`department_name` = 'Sales' OR d.`department_name` = 'IT ';