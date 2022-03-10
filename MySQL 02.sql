#在java中为1001，这里的‘1’ 和 java中的“1”是一样的 因为sql中字符串是以 ‘  ’  修饰的
SELECT 100 + '1'
FROM DUAL;# DUAL 伪表
#在SQL中结果为101，此时，字符串转换为了数值（隐式转换）

SELECT 100 + 'a' # 结果为100，此时'a' 看作0处理
FROM DUAL;# DUAL 伪表

SELECT 100 + NULL # 结果为null，null参与运算结果都是null
FROM DUAL;# DUAL 伪表

# 除法 / DIV
SELECT	100,100 * 1,100* 1.0,100 / 1.0,100 /2,
 100 + 2 * 5 / 2,100 / 3,100 DIV 0 # 分母为0，结果为null
FROM DUAL;

#取模 % MOD
#练习
SELECT last_name,salary FROM employees
WHERE employee_id % 2 = 0;


#比较运算符
SELECT 1 = 2,1!= 2,1 = '1',1 = 'a',0 = 'a'
FROM DUAL;

SELECT 'a' = 'a','ab'= 'ab','a' = 'b'
FROM DUAL;

SELECT 1 = NULL,NULL = NULL
FROM DUAL;

 
#安全等于
SELECT 1 <=> NULL,NULL <=> NULL
FROM DUAL;

#查询表中commission_pct为null的数据
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct <=> NULL;#输出两个对比都是null的值
# WHERE NOT commission_pct <=> NULL;输出其中一个对比是null的值


#关键字
#is null \ is not null \ isnull
SELECT last_name,salary,commission_pct
FROM employees
WHERE ISNULL(commission_pct);


#least() \ greatest()
SELECT LEAST(first_name,last_name)
FROM employees;

#between ... and
#查询工资在6000-8000之间的员工信息
SELECT employee_id,last_name,salary 
FROM employees
WHERE salary BETWEEN 6000 AND 8000;
#WHERE salary NOT BETWEEN 6000 AND 8000;


#in(set) \not in(set)
#查询部门为10，20，30的员工信息
SELECT employee_id,last_name,salary,department_id 
FROM employees
WHERE department_id IN(10,20,30);

#查询工资不为6000，7000，8000的员工信息
SELECT employee_id,last_name,salary,department_id 
FROM employees
WHERE salary NOT IN(6000,7000,8000);

# like:模糊查询
#查询last_name中包含字符'a'的员工信息
# % ：代表不确定个数的字符
SELECT last_name 
FROM employees
WHERE last_name LIKE '%a%';
# WHERE last_name LIKE 'a%';查询last_name中以'a'开头的员工信息

#查询last_name中既包含字符'a'又包含字符'e'的员工信息
SELECT last_name 
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';

#查询last_name中第2个字符是'a'的员工信息
SELECT last_name 
FROM employees
WHERE last_name LIKE '_a%' ;

#查询last_name中第2个字符是_且第三个是'a'的员工信息
# 转义字符：\
SELECT last_name 
FROM employees
WHERE last_name LIKE '_\_a%' ;


#正则表达式运算符：regexp \ rlike
SELECT 'test' REGEXP '^te','test' REGEXP 't$','test' REGEXP 'es'
FROM DUAL;


#逻辑运算符


#相关练习1
#1.选择工资不在5000到12000的员工的姓名和工资
SELECT last_name,salary
FROM employees
WHERE salary NOT BETWEEN 5000 AND 12000;

#相关练习2
#2.选择在20或50号部门工作的员工姓名和部门号
SELECT last_name,department_id
FROM employees
WHERE department_id IN(20,50);

#相关练习3
#3.选择公司中没有管理者的员工姓名及job_id
SELECT last_name,job_id,manager_id
FROM employees
WHERE manager_id IS NULL;

#相关练习4
#4.选择公司中有奖金的员工姓名，工资和奖金级别
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;


#相关练习5
#5.选择员工姓名的第三个字母是a的员工姓名
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';


#相关练习6
#6.选择姓名中有字母a和k的员工姓名
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%k%';

#相关练习7
#7.显示出表 employees 表中 first_name 以 'e'结尾的员工信息
SELECT first_name,last_name
FROM employees
# where first_name regexp 'e$';
WHERE first_name LIKE '%e';

#相关练习8
#8.显示出表 employees 部门编号在 80-100 之间的姓名、工种
SELECT last_name,job_id,department_id
FROM employees
WHERE department_id BETWEEN 80 AND 100 ;


#相关练习9
#9.显示出表 employees 的 manager_id 是 100,101,110 的员工姓名、工资、管理者id
SELECT last_name,salary,manager_id
FROM employees
WHERE manager_id IN(100,101,110);