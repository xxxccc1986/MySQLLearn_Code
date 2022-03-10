#创建一张新的表
CREATE TABLE IF NOT EXISTS the_table (
id INT,
the_name VARCHAR(15),
hire_date DATE,
salary DOUBLE(10,2)
				     );
				    
DESC the_table;


#单条逐个添加
#方式一 没有指明要添加的字段
#此方式添加数据需要按照声明字段的先后顺序添加
INSERT INTO the_table
VALUES (1,'jack','2012-12-21',2000);

#方式二 指明要添加的字段(推荐)
INSERT INTO the_table(id,hire_date,salary,the_name)
VALUES (2,'2012-12-21',2000,'merry');

#没有进行赋值的salary的值为null
INSERT INTO the_table(id,hire_date,the_name)
VALUES (3,'2012-12-21','merry');

#方式三 推荐
#同时插入多条数据
INSERT INTO the_table(id,the_name,salary)
VALUES 
(4,'张三',2000),
(5,'李四',6000);


#通过查询结果插入到表
INSERT INTO the_table(id,the_name,salary,hire_date)
#一个查询语句
SELECT employee_id,last_name,salary,hire_date#此处的字段要和添加到上表的字段相互对应
FROM employees
WHERE department_id IN (60,70);

SELECT * FROM the_table;

#更新数据
 UPDATE the_table
 SET hire_date = SYSDATE()
 WHERE id = 5;

#同时修改同一个数据中的多个字段
UPDATE the_table
SET hire_date = NOW(),salary = 3000
WHERE id = 4;

#将表中姓名包含字符a的提薪 20%
UPDATE the_table
SET salary = salary * 2
WHERE the_name LIKE '%a%';


#删除数据
DELETE FROM the_table
WHERE id = 1;

#MySQL8 计算列
CREATE TABLE test1(
a INT,
b INT,
c INT GENERATED ALWAYS AS (a + b) VIRTUAL # c即为计算列

);

INSERT INTO test1(a,b)
VALUES (1,2);

SELECT * FROM test1;
UPDATE test1
SET a = 2;

#综合练习

# 1、创建数据库test01_library
CREATE DATABASE IF NOT EXISTS test01_library CHARACTER SET 'utf8';
USE test01_library;

# 2、创建表 books，表结构如下：
CREATE TABLE IF NOT EXISTS books(
id INT,
`name` VARCHAR(50),
`authors` VARCHAR(100),
price FLOAT,
pubdate  YEAR,
note  VARCHAR(100),
num INT
				);
				
SHOW TABLES;


# 3、向books表中插入记录
# 1）不指定字段名称，插入第一条记录
INSERT INTO books
VALUES (1,'Tal of AAA','Dickes',23,1995,'novel',11);

# 2）指定所有字段名称，插入第二记录
INSERT INTO books (id,NAME,AUTHORS,price,pubdate,note,num)
VALUES (2,'EmmaT','Jane lura',35,1993,'joke',22);

# 3）同时插入多条记录（剩下的所有记录）
INSERT INTO books (id,NAME,AUTHORS,price,pubdate,note,num)
VALUES (3,'Story of Jane ','Jane Tim',40,2001,'novel',0),
       (4,'Lovey Day','George Byron',20,2005,'novel',30),
       (5,'Old land ','Honore Blade',30,2010,'law',0),
       (6,'The Battle','Upton Sara',30,1999,'medicine',40),
       (7,'Rose Hood','Richard haggard',28,2008,'cartoon',28);
       
# 4、将小说类型(novel)的书的价格都增加5。
UPDATE books
SET price = price + 5
WHERE note = 'novel';

# 5、将名称为EmmaT的书的价格改为40，并将说明改为drama。
UPDATE books
SET price = 40 ,note = 'drama'
WHERE NAME = 'EmmaT';

# 6、删除库存为0的记录。
DELETE FROM books
WHERE num = 0;

# 7、统计书名中包含a字母的书
SELECT NAME
FROM books
WHERE NAME LIKE '%a%';

# 8、统计书名中包含a字母的书的数量和库存总量
SELECT COUNT(*),SUM(num)
FROM books
WHERE NAME LIKE '%a%';

# 9、找出“novel”类型的书，按照价格降序排列
SELECT * 
FROM books
WHERE note = 'novel'
ORDER BY price DESC;

# 10、查询图书信息，按照库存量降序排列，如果库存量相同的按照note升序排列(二级排序)
SELECT * 
FROM books
ORDER BY num DESC,note ASC;


# 11、按照note分类统计书的数量
SELECT note,COUNT(*)
FROM books
GROUP BY note;

# 12、按照note分类统计书的库存量，显示库存量超过30本的
SELECT note,SUM(num)
FROM books
GROUP BY note
HAVING SUM(num)> 30;

#- 13、查询所有图书，每页显示5本，显示第二页
SELECT *
FROM books
LIMIT 5,5;
 
# 14、按照note分类统计书的库存量，显示库存量最多的
#方式一
SELECT note,SUM(num)
FROM books
GROUP BY note
HAVING SUM(num)
ORDER BY note DESC
LIMIT 0,1;

#方式二
SELECT note,SUM(num) 
FROM books
GROUP BY note
HAVING SUM(num) = (
	SELECT MAX(zonghe)
	FROM 
	(SELECT note,SUM(num) zonghe
	FROM books
	GROUP BY note
	) t_zonghe
		   );

#- 15、查询书名达到10个字符的书，不包括里面的空格
SELECT NAME
FROM books
WHERE CHAR_LENGTH(REPLACE(NAME,' ','')) > 10;
  

# 16、查询书名和类型，其中note值为novel显示小说，law显示法律，medicine显示医药，cartoon显示卡通，joke显示笑话
SELECT NAME '书名',note,CASE   WHEN note = 'novel' THEN '小说'
			WHEN note = 'law' THEN '法律'
			WHEN note = 'medicine' THEN '医药'
			WHEN note = 'cartoon' THEN '卡通'
			WHEN note = 'joke' THEN  '笑话'
			ELSE '其他'
			END '书籍类型'
FROM books;

# 17、查询书名、库存，其中num值超过30本的，显示滞销，大于0并低于10的，显示畅销，为0的显示需要无货
SELECT NAME AS '书名',num,CASE WHEN num > 30 THEN '滞销'
			WHEN num < 10 AND num > 0   THEN '畅销'
			WHEN num = 0 THEN '需要补货'
			ELSE '正常'
			END '库存情况'
FROM books;

# 18、统计每一种note的库存量，并合计总量
SELECT IFNULL(note,'合计总量') AS note,SUM(num) AS '库存量'
FROM books
GROUP BY note WITH ROLLUP;

# 19、统计每一种note的数量，并合计总量
SELECT IFNULL (note,'总量') AS note,COUNT(note) '数量'
FROM books 
GROUP BY note WITH ROLLUP;

# 20、统计库存量前三名的图书
SELECT NAME,num
FROM books
ORDER BY num DESC
LIMIT 0,3;

# 21、找出最早出版的一本书
SELECT *
FROM books 
GROUP BY pubdate
LIMIT 1;

# 22、找出novel中价格最高的一本书
SELECT *
FROM books 
WHERE note = 'novel'
ORDER BY price DESC
LIMIT 1;

# 23、找出书名中字数最多的一本书，不含空格
SELECT *
FROM books
ORDER BY  CHAR_LENGTH(REPLACE(NAME,' ','')) DESC
LIMIT 1;

