#1.查询和Zlotkey相同部门的员工姓名和工资
SELECT e.last_name,e.salary
FROM employees e
WHERE e.`department_id` = (
			SELECT department_id
			FROM employees 
			WHERE last_name = 'Zlotkey'
);


#2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT job_id,last_name,salary
FROM employees
WHERE salary > (
		SELECT AVG(salary)
		FROM employees
		);
		
#3.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name, job_id, salary
SELECT last_name,job_id,salary
FROM employees
WHERE  salary > ALL (
		SELECT salary
		FROM employees
		WHERE job_id = 'SA_MAN'
		);

#4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT e.employee_id,e.last_name
FROM employees e
WHERE e.`department_id` IN (
			SELECT DISTINCT department_id
			FROM employees
			WHERE last_name LIKE '%u%'
			);
			
#5.查询在部门的location_id为1700的部门工作的员工的员工号
SELECT e.employee_id
FROM employees e
WHERE e.`department_id` IN(
			   SELECT d.department_id
			   FROM departments d
			   WHERE d.`location_id` = 1700
			   );

#6.查询管理者是King的员工姓名和工资
SELECT e.last_name,e.salary,e.`manager_id`
FROM employees e
WHERE e.`manager_id` IN (
			SELECT employee_id
			FROM employees e
			WHERE e.`last_name` = 'King'
			);

#7.查询工资最低的员工信息: last_name, salary
SELECT e.last_name,e.salary
FROM employees e
WHERE  e.salary = (SELECT MIN(salary)
		   FROM employees
	           );

#8.查询平均工资最低的部门信息
#①查询各个部门的平均工资
#②将结果集当成一个字段并构建新的表,并查出avg_sal字段中的最小值
#③查询employees表中的部门平均工资等于此最小值，并返回此部门的id
#方法一
SELECT *
FROM departments
WHERE department_id = (
	SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) = (
			SELECT MIN(avg_sal)
			FROM (
			SELECT AVG(salary) avg_sal
			FROM employees
			GROUP BY department_id) t_avg
			)
			);


#方法二
#部门的平均工资<= all，即为部门的平均工资等于所有部门的平均工资的最小值		
SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) <= ALL (
		SELECT AVG(salary) 
		FROM employees
		GROUP BY department_id 
		);		
    
#9-.查询平均工资最低的部门信息和该部门的平均工资（相关子查询）
SELECT e.department_id,AVG(salary)
FROM employees e
GROUP BY e.department_id
HAVING AVG(salary) = (
			SELECT MIN(avg_sal)
			FROM (SELECT AVG(salary) avg_sal
			FROM employees
			GROUP BY department_id) t_avg
			);

##9-.查询平均工资最低的部门信息和该部门的平均工资（相关子查询）

SELECT d.*,AVG(salary)
FROM departments d,employees e
WHERE d.department_id = (
	SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) = (
			SELECT MIN(avg_sal)
			FROM (
			SELECT AVG(salary) avg_sal
			FROM employees
			GROUP BY department_id) t_avg
			)
			)
AND e.`department_id` = d.`department_id`;

#方式二
SELECT d.*,(SELECT AVG(salary) FROM employees  WHERE department_id = d.`department_id`) asvg_sal
FROM departments d
WHERE d.department_id = (
	SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) = (
			SELECT MIN(avg_sal)
			FROM (
			SELECT AVG(salary) avg_sal
			FROM employees
			GROUP BY department_id) t_avg
			)
			);		

#10.查询平均工资最高的 job 信息
#方式一
SELECT * 
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) = (
					SELECT MAX(avg_sal)
					FROM (
						SELECT AVG(salary) avg_sal
						FROM employees 
						GROUP BY job_id
					     ) t_avg
					)
		);

#方式二
SELECT * 
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) >= ALL (
					SELECT AVG(salary)
					FROM employees 
					GROUP BY job_id    
					)

		);
		
#方式三 
SELECT * 
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) = (
					SELECT AVG(salary) avg_ssal
					FROM employees 
					GROUP BY job_id 
					#利用排序显示最高的第一行数据，
					#用这个数据去跟AVG(salary)比较，得到job_id
					#再根据job_id去jobs表中筛出数据 
					ORDER BY avg_ssal DESC 
					LIMIT 0,1 
					)

		);
		
#方式四 
SELECT j.* 
FROM jobs j,#将下方的排序后得到的唯独的一行数据当成一张表，
	    #再根据jobs和此表的job_id比较得到数据
	   (SELECT job_id,AVG(salary) avg_ssal 
	   FROM employees 
	   GROUP BY job_id 
	   ORDER BY avg_ssal DESC
	   LIMIT 0,1 ) t_jobs 
	  
WHERE j.job_id = t_jobs.job_id;





				
#11.查询部门平均工资高于公司平均工资的部门有哪些?
SELECT department_id,AVG(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) >(
			SELECT AVG(salary)
			FROM employees 
			); 


#-12.查询出公司中所有 manager 的详细信息
SELECT employee_id, last_name, salary
FROM employees 
WHERE employee_id IN (
		      SELECT manager_id
		      FROM employees
			  			
);

SELECT employee_id, last_name, salary
FROM employees e
WHERE EXISTS (
	      SELECT manager_id
	      FROM employees e1
	      WHERE e.`employee_id` = e1.manager_id
			  			
);


#13.各个部门中 最高工资中最低的那个部门的 最低工资是多少?
SELECT MIN(salary),department_id
FROM employees
WHERE department_id = (
			SELECT department_id
			FROM employees 
			GROUP BY department_id
			HAVING AVG(salary) = (
						SELECT MIN(avg_sal)
						FROM (SELECT MAX(salary) avg_sal
						FROM employees
						WHERE department_id IS NOT NULL
						GROUP BY department_id) t_max
						)
);

#14.查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id = (
SELECT manager_id
FROM departments
WHERE department_id = (
	SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) = (
			SELECT MAX(avg_sal)
			FROM (
				SELECT AVG(salary) avg_sal
				FROM employees
				GROUP BY department_id
				) t_avg
				)

)
);

#15. 查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号
SELECT department_id
FROM departments
WHERE department_id NOT IN (
		SELECT DISTIN CT department_id
		FROM employees
		WHERE job_id = 'ST_CLERK' 		
		)
AND department_id IS NOT NULL;

#16. 选择所有没有管理者的员工的last_name
SELECT last_name
FROM employees e 
WHERE NOT EXISTS (
		SELECT *
		FROM employees mgr
		WHERE e.`manager_id` = mgr.`employee_id`
		
			
);

#17．查询员工号、姓名、雇用时间、工资，其中员工的管理者为 'De Haan'
SELECT employee_id,last_name,hire_date,salary
FROM employees
WHERE manager_id IN (
		SELECT employee_id 
		FROM employees
		WHERE last_name ='De Haan'

);


#18.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资（相关子查询）
SELECT employee_id,last_name,salary
FROM employees e1
WHERE e1.`salary` > (
		SELECT AVG(salary)
		FROM employees e2
		WHERE e1.`department_id` = e2.`department_id`

);


#19.查询每个部门下的部门人数大于 5 的部门名称（相关子查询）
SELECT department_name,department_id
FROM departments d
WHERE 5 < (
	   SELECT COUNT(employee_id)
	   FROM employees e
	   WHERE e.`department_id` = d.`department_id`
);


#20.查询每个国家下的部门个数大于 2 的国家编号（相关子查询）
SELECT country_id
FROM locations l
WHERE 2 < ( 
	   SELECT COUNT(department_id)
	   FROM departments d
	   WHERE d.`location_id` = l.`location_id`

);
 
