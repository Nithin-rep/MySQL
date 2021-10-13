CREATE DATABASE company_data;
USE company_data;

CREATE TABLE employee(
emp_id INT PRIMARY KEY NOT NULL,
first_name VARCHAR(20),
lASt_name VARCHAR(20),
birth_date DATE,
sex VARCHAR(1),
salary INT,
supper_id int,
branch_id int
);

CREATE TABLE branch(
branch_id int PRIMARY KEY,
branch_name VARCHAR(20),
manager_id int,
manager_start_date date,
FOREIGN KEY(manager_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);


ALTER TABLE employee ADD FOREIGN KEY (branch_id) references branch(branch_id) ON DELETE SET NULL;
ALTER TABLE employee ADD FOREIGN KEY (supper_id) references employee(emp_id) ON DELETE SET NULL;

CREATE TABLE clientt(

client_id INT PRIMARY KEY,
client_name VARCHAR(20),
branch_id INT,
foreign key(branch_id) references branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with(
emp_id int,
client_id int ,
total_sales int,
PRIMARY KEY(emp_id,client_id),
FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY(client_id) REFERENCES clientt(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
branch_id int,
supplier_name VARCHAR(20),
supplier_type VARCHAR(20),
PRIMARY KEY(branch_id,supplier_name),
FOREIGN KEY(branch_id) references branch(branch_id) ON DELETE CASCADE
);

describe branch_supplier;

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');
SET SQL_SAFE_UPDATES=0;
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;
SET SQL_SAFE_UPDATES=1;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENTT
INSERT INTO clientt VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO clientt VALUES(401, 'Lackawana COUNTry', 2);
INSERT INTO clientt VALUES(402, 'FedEx', 3);
INSERT INTO clientt VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO clientt VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO clientt VALUES(405, 'Times Newspaper', 3);
INSERT INTO clientt VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);


SET SQL_SAFE_UPDATES=0;
UPDATE branch SET branch_name = 'Corporate' WHERE branch_name = 'cimps';
SET SQL_SAFE_UPDATES=1;




-- COLUMN FILTERS

-- To see only first and last name in employee table
SELECT first_name,last_name FROM employee;






-- ORDER BY OPERATIONS

-- TO order branch_supplier table
SELECT * FROM branch_supplier ORDER BY supplier_name AND supplier_type;

-- TO order employee table by salary in descending order
SELECT * FROM employee ORDER BY salary DESC;

-- TO order employee table by sex and first_name
SELECT * FROM employee ORDER BY sex, first_name;






-- LIMIT OPERATION
-- To see first 5 rows in  employee table
SELECT * FROM employee LIMIT 5;






-- ALIAS FOR THE COLUMNS

-- To see only first name AS forename and lASt name AS surname in employee table
SELECT first_name AS forename,lASt_name AS surname FROM employee;





-- BASIC ADDITION OPERARTORS (COUNT, SUM, AVG)

-- To see the types of sex in employee table
SELECT DISTINCT sex FROM employee;

-- To COUNT employees in employee table
SELECT COUNT(emp_id) FROM employee;

-- To find female employees bron after 1970 FROM employee table
SELECT COUNT(emp_id) FROM employee WHERE sex = 'F' and birth_date > '1971-01-01';

-- To find average salary of all employees
SELECT AVG(salary) FROM employee;

-- To find average salary of male employees
SELECT AVG(salary) FROM employee WHERE sex='M';

-- To find SUM of salary of employees
SELECT SUM(salary) FROM employee;



-- GROUP BY OPERATOR

-- To find the number of employees FROM each sex category (using GROUP BY)
SELECT COUNT(emp_id),sex FROM employee GROUP BY sex;

-- To find total sales of each salesman
SELECT SUM(total_sales),emp_id FROM works_with GROUP BY emp_id;




-- WILD OPERATORS (LIKE)

use company_data;
SELECT supplier_name FROM branch_supplier WHERE supplier_name LIKE '%Labels';

-- To find employee born in october
SELECT * FROM employee WHERE birth_date LIKE '____-11%';

-- To find if there are any school clients 
SELECT * FROM clientt WHERE client_name LIKE '%school%';



-- UNION

-- To find list of employees and branch name
SELECT first_name FROM employee
UNION
SELECT 	branch_id FROM branch;

-- To find a list of all clients and branch suppliers name
SELECT client_name, clientt.branch_id FROM clientt
UNION
SELECT supplier_name, branch_supplier.branch_id  FROM branch_supplier;

-- To find a list of all money spent or earnt by the company
SELECT sum(salary) as money_left from Employee
UNION 
SELECT sum(total_sales) FROM works_with;





-- JOINS

-- To add new branch into the branch table
INSERT INTO branch VALUES(4,'BUFF', NULL, NULL);

SELECT clientt.client_name, clientt.client_id, works_with.total_sales
FROM clientt
JOIN works_with
ON clientt.client_id = works_with.client_id;




-- Nested queries

-- To find name of employees who sold over 30,000 to single client
SELECT employee.first_name, employee.last_name FROM employee WHERE employee.emp_id IN (
SELECT works_with.emp_id FROM works_with WHERE works_with.total_sales > 30000
);

-- To find the name of all the clients Micheal Scott manages knowing michela's id

SELECT clientt.client_name FROM clientt WHERE clientt.branch_id IN( 
SELECT branch.branch_id FROM branch WHERE branch.manager_id = 102
);

-- To find the list of employees who are payed more than 70,000 but have sales  with individual clients less than 20,000

SELECT employee.first_name FROM employee WHERE employee.salary > 70000 AND emp_id IN(
SELECT works_with.emp_id FROM works_with WHERE total_Sales < 20000 GROUP BY emp_id);


-- TRIGGERS



 

