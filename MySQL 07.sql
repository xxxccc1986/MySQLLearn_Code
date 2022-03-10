#方法一
SELECT last_name,salary
FROM employees
WHERE last_name = 'Abel';

SELECT last_name,salary
FROM employees
WHERE salary > 11000;



#方法二
#自连接
SELECT e2.last_name,e2.salary
FROM employees e JOIN employees e2 
WHERE e.last_name = 'Abel'
AND e2.`salary` > 11000;

#方式三
#子查询
SELECT last_name,salary
FROM employees  
WHERE salary > (SELECT salary
		FROM employees 
		WHERE last_name = 'Abel'
		);

#查询工资大于149号员工的员工信息
SELECT last_name,salary
FROM employees 
WHERE salary > (SELECT salary
		FROM employees
		WHERE employee_id = 149
		);

#返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资


SELECT job_id,last_name,salary
FROM employees 
WHERE job_id = (SELECT job_id 
		FROM employees
		WHERE employee_id = 141
		)
AND salary > (  SELECT salary
	        FROM employees
	        WHERE employee_id = 143
	        );

#返回公司工资最少的员工的last_name,job_id和salary
SELECT last_name,job_id,salary
FROM employees
WHERE salary = (
		SELECT MIN(salary)
		FROM employees
);

#查询与141号员工的manager_id和department_id相同的其他员工的employee_id，manager_id，department_id
SELECT employee_id,manager_id,department_id
FROM employees
WHERE manager_id = (
			SELECT manager_id
			FROM employees
			WHERE employee_id = 141 
			)
AND department_id = (
			SELECT department_id 
			FROM employees
			WHERE employee_id = 141
			)
AND employee_id != 141;

#查询最低工资大于50号部门最低工资的部门id和其最低工资
#这个部门的最低工资都比50号部门的最低工资高，返回这个部门的id，以及这个部门中的最低工资
#查询50号部门的最低工资
SELECT department_id,MIN(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING MIN(salary) > (
			SELECT MIN(salary)
			FROM employees
			WHERE department_id= 50
			);
			

#：显式员工的employee_id,last_name和location。
#其中，若员工department_id与location_id为1800的department_id相同，
#则location为’Canada’，其余则为’USA’。
SELECT e.employee_id,e.last_name,CASE e.`department_id` WHEN (SELECT department_id 
							      FROM departments 
							      WHERE location_id = 1800) 
							      THEN 'Canada'
							      ELSE 'USA'
							      END  "location"
FROM employees e;


#返回其它job_id中比job_id为‘IT_PROG’部门任一工资低的员工的员工号、姓名、job_id 以及salary
SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id != 'IT_PROG'
AND salary < ANY(
		SELECT salary
		FROM employees
		WHERE job_id = 'IT_PROG'
		);
		
# 返回其它job_id中比job_id为‘IT_PROG’部门所有工资低的员工的员工号、姓名、job_id 以及salary

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id != 'IT_PROG'
AND salary < ALL (
		SELECT salary
		FROM employees
		WHERE job_id = 'IT_PROG'
		);
		
#查询平均工资最低的部门id

SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
			SELECT MIN(avg_sal)
			FROM (
			SELECT AVG(salary) avg_sal
			FROM employees
			GROUP BY department_id
			HAVING department_id IS NOT NULL
			)t_avg
);

#空值问题
#Not in 实际上就是 <>ALL 而用大于或小于来比较Null值的话，都返回null的。(false)
SELECT last_name
FROM employees
WHERE employee_id NOT IN (
			SELECT manager_id
			FROM employees
);

#相关子查询
#查询员工中工资大于本部门平均工资的员工的last_name,salary和其department_id
#方式一：
SELECT e1.last_name,e1.salary,e1.department_id
FROM employees e1
WHERE e1.salary > (
		SELECT AVG(salary)
		FROM employees e2
		WHERE e2.department_id = e1.`department_id`
);


#方式二
SELECT e.department_id,e.salary
FROM employees e JOIN  (SELECT department_id,AVG(salary) the_avg#此处必须给AVG(salary)重新命名，让它不充当一个函数出现
			FROM employees
			WHERE department_id IS NOT NULL
			GROUP BY department_id) t_dept_avg
ON e.`department_id` = t_dept_avg.department_id
WHERE e.`salary` > t_dept_avg.the_avg;


#：若employees表中employee_id与job_history表中employee_id相同的数目不小于2，
#输出这些相同id的员工的employee_id,last_name和其job_id
SELECT * FROM job_history;

SELECT employee_id,last_name,job_id
FROM employees e
WHERE 2 <= (
	     SELECT COUNT(*)
	     FROM job_history j
	     WHERE e.`employee_id` = j.`employee_id`	
	    );
	    
	    
#查询公司管理者的employee_id，last_name，job_id，department_id信息
SELECT employee_id,last_name,job_id,department_id
FROM employees
WHERE `employee_id` IN (
			SELECT DISTINCT manager_id
			FROM employees
			);
			
#使用EXISTS
SELECT employee_id,last_name,job_id,department_id
FROM employees e
WHERE EXISTS (
	      SELECT * 
	      FROM employees e2
	      WHERE e.`employee_id` = e2.`manager_id`
		);
#使用NO EXISTS
#查询departments表中，不存在于employees表中的部门的department_id和department_name
SELECT department_id,department_name
FROM departments d
WHERE NOT EXISTS (
		SELECT department_id 
		FROM employees e
		WHERE d.`department_id` = e.`department_id`
		);