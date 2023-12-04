SELECT * FROM employee.data_science_team;
SELECT * FROM employee.emp_record_table;
SELECT * FROM employee.proj_table;

## showing employee details:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table;

## Showing employee details with specific EMP_RATING:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING,
case
when EMP_RATING <2 then " Less than two "
when EMP_RATING >4 then " More than 4 "
else " Between 2 and 4 "
end RATING
FROM emp_record_table order by RATING;
 
 ## Concatenating FIRST_NAME and LAST_NAME for Finance department:
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT = 'Finance';

## List employees with subordinates:
SELECT e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.GENDER, e.DEPT, COUNT(r.EMP_ID) AS REPORTERS
FROM emp_record_table e
LEFT JOIN emp_record_table r ON e.EMP_ID = r.MANAGER_ID
GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.GENDER, e.DEPT
HAVING REPORTERS > 0 OR e.EMP_ID = 1;

## List employees from healthcare and finance using UNION:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT
FROM emp_record_table
WHERE DEPT = 'Healthcare'
UNION
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT
FROM emp_record_table
WHERE DEPT = 'Finance';

##  Group employees by department with max rating:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING
FROM (
    SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING,
           RANK() OVER (PARTITION BY DEPT ORDER BY EMP_RATING DESC) AS Rnk
    FROM emp_record_table
) ranked
WHERE Rnk = 1;

##  Calculating min and max salary by role:
SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE;

##  Creating a view for employees with salary more than 6000:
CREATE VIEW High_Salary_Employees AS
SELECT *
FROM emp_record_table
WHERE SALARY > 6000;
SELECT * FROM High_Salary_Employees;
 
## Showing query for employees with more than 10 years of experience:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP
FROM emp_record_table
WHERE EXP > 10;

##  Assigning ranks based on experience:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP,
       CASE
           WHEN EXP <= 2 THEN 'JUNIOR DATA SCIENTIST'
           WHEN EXP <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
           WHEN EXP <= 10 THEN 'SENIOR DATA SCIENTIST'
           WHEN EXP <= 12 THEN 'LEAD DATA SCIENTIST'
           ELSE 'MANAGER'
       END AS JOB_PROFILE
FROM emp_record_table;

 ## Query to calculate bonus:
SELECT EMP_ID, FIRST_NAME, LAST_NAME, (0.05 * SALARY * EMP_RATING) AS BONUS
FROM emp_record_table;

##  Average salary distribution by continent and country:
SELECT CONTINENT, COUNTRY, AVG(SALARY) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY;
