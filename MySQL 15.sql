#触发器

CREATE TABLE test_trigger (
id INT PRIMARY KEY AUTO_INCREMENT,
t_note VARCHAR(30)
);

CREATE TABLE test_trigger_log (
id INT PRIMARY KEY AUTO_INCREMENT,
t_log VARCHAR(30)
);
SELECT * FROM test_trigger_log;

#创建触发器
#创建触发器：创建名称为before_insert的触发器，
#向test_trigger数据表插入数据之前，
#向test_trigger_log数据表中插入before_insert的日志信息。
DELIMITER $
CREATE TRIGGER before_insert
BEFORE INSERT ON test_trigger
FOR EACH ROW 
BEGIN 
	 INSERT INTO test_trigger_log(t_log)
	 VALUES ('测试语句');
END $

DELIMITER ;

INSERT INTO test_trigger(t_note)
VALUES ('测试');

SELECT * FROM test_trigger;
SELECT * FROM test_trigger_log;

#创建名称为after_insert的触发器，向test_trigger数据表插入数据之后，
#向test_trigger_log数据表中插入after_insert的日志信息。
#delimiter $
CREATE TRIGGER after_insert
AFTER INSERT ON test_trigger
FOR EACH ROW
#begin
INSERT INTO test_trigger_log(t_log)
VALUES ('测试语句');
#end $

#delimiter ;

INSERT INTO test_trigger(t_note)
VALUES ('测试1');

SELECT * FROM test_trigger;
SELECT * FROM test_trigger_log;

#定义触发器“salary_check_trigger”，基于员工表“employees”的INSERT事件，
#在INSERT之前检查将要添加的新员工薪资是否大于他领导的薪资，
#如果大于领导薪资，则报sqlstate_value为'HY000'的错误，从而使得添加失败。
DELIMITER $
CREATE TRIGGER salary_check_trigger
BEFORE INSERT ON emp
FOR EACH ROW 
BEGIN 
	DECLARE mgr_sal DOUBLE DEFAULT 0.0;
	
	SELECT salary INTO mgr_sal FROM emp WHERE employee_id = new.manager_id;
	
	IF new.salary > mgr_sal
		THEN SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = '薪资高于领导薪资错误';
	END IF;
	
END $

DELIMITER ;

SELECT * FROM emp;

#触发触发器，添加失败
INSERT INTO emp(employee_id,last_name,email,hire_date,job_id,salary,manager_id)
VALUES (300,'Jack','123456@gmail.com',CURDATE(),'AD_VP',10000,103);

#MySQL 8.0 新特性 窗口函数
