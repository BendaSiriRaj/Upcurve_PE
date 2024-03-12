-- DATABASE SELECTION --
use HRDB;

-- JOB_GRADES TABLE --
create table JOB_GRADES(
grade_level varchar(4),
lowest_sal int,
highest_sal int,
primary key(grade_level)
);

insert into JOB_GRADES values('A',1000,2999),
('B',3000,5999),
('C',6000,9999),
('D',10000,14999),
('E',15000,24999),
('F',25000,40000);

-- 1. QUERY TO DISPLAY LastName, DepartmentNumber and DepartmentName FOR ALL EMPLOYEES --
select emp.last_name, emp.department_id, dept.department_name 
from EMPLOYEES as emp JOIN DEPARTMENTS as dept 
on emp.department_id = dept.department_id;

-- 2. QUERY TO LIST UNIQUE JOBS IN DEPARTMENT 30 ALONG WITH LocationId --
select distinct emp.job_id, dept.location_id 
from EMPLOYEES as emp, DEPARTMENTS as dept
where emp.department_id = dept.department_id
and emp.department_id=30;

-- 3. QUERY TO DISPLAY LastName, DepartmentName, Location_id and City OF ALL EMPLOYEES EARNING A COMMISSION --
select emp.last_name, dept.department_name, dept.location_id, lct.city 
from EMPLOYEES as emp, DEPARTMENTS as dept, LOCATIONS as lct
where emp.department_id=dept.department_id
and dept.location_id=lct.location_id
and emp.commission_pct is not null;

-- 4. QUERY TO DISPLAY LastName, DepartmentName, LocationId and City OF EMPLOYEES HAVING 'a' IN THEIR LAST NAME --
select emp.last_name, dept.department_name, dept.location_id, lct.city
from EMPLOYEES as emp, DEPARTMENTS as dept, LOCATIONS as lct
where emp.department_id = dept.department_id
and dept.location_id = lct.location_id
and last_name like '%a%';

-- 5. QUERY TO DISPLAY LastName, Job, DepartmentNumber and DepartmentName FOR EMPLOYEES WORKING IN TORONTO --
select emp.last_name, emp.job_id, emp.department_id, dept.department_name
from EMPLOYEES as emp join DEPARTMENTS as dept
on emp.department_id = dept.department_id
join LOCATIONS as lct
on dept.location_id = lct.location_id
where lct.city='Toronto';

-- 6. QUERY TO DISPLAY LastName, EmployeeNumber, Manager's LastName and ManagerNumber as Employee, Emp#, Manager, Manager# --
select emp.last_name as "Employee", emp.employee_id as "Emp#", mang.last_name as "Manager", mang.employee_id as "Manager#"
from EMPLOYEES as emp
join EMPLOYEES as mang
on emp.manager_id = mang.employee_id;

-- 7. MODIFY THE ABOVE QUERY INCLUDE KING FOR EMPLOYEE WITH NO MANAGER AND ORDER THE RESULT BY EMPLOYEE NUMBER --
select emp.last_name as "Employee", emp.employee_id as "Emp#", mang.last_name as "Manager", mang.employee_id as "Manager#"
from EMPLOYEES as emp
left outer join EMPLOYEES as mang
on emp.manager_id = mang.employee_id
order by emp.employee_id;

-- 8. QUERY TO DISPLAY LastName, DepartmentNumbers AND EMPLOYEES WORKING IN THE SAME DEPARTMENT AS A GIVEN EMPLOYEE --
select emp.department_id as "Department", emp.last_name as "Employee", col.last_name "Colleague"
from EMPLOYEES as emp
join EMPLOYEES as col
on emp.department_id = col.department_id
where emp.employee_id <> col.employee_id
order by emp.department_id, emp.last_name, col.last_name;

-- 9.QUERY THAT DISPLAYS Name, Job, DepartmentName, Salary and Grade FOR ALL EMPLOYEES --
select emp.last_name, emp.job_id, dept.department_id, emp.salary, jb.grade_level
from EMPLOYEES as emp
join DEPARTMENTS as dept
on emp.department_id = dept.department_id
join JOB_GRADES jb
on emp.salary between jb.lowest_sal and jb.highest_sal;

-- 10. QUERY TO DISPLAY THE Name AND HireDate OF ALL EMPLOYEES HIRED AFTER EMPLOYEE "Davies" --
select emp.last_name, emp.hire_date 
from EMPLOYEES as emp
where emp.hire_date > (select emp.hire_date from EMPLOYEES as emp where last_name="Davies");

-- 11. QUERY TO DISPLAY Names, HireDates FOR ALL EMPLOYEES WHO WERE HIRED BEFORE THEIR MANAGERS --
-- ALONG WITH THEIR MANAGER'S Names AND HireDates. --
-- LABELLING AS "Employee", "Emp Hired", "Manager", "Manager hired: --
select emp.last_name as "Employee", emp.hire_date as "Emp hired", mang.last_name as "Manager", mang.hire_date as "Manager hired"
from EMPLOYEES as emp 
join EMPLOYEES as mang
on emp.manager_id = mang.employee_id 
where emp.hire_date < mang.hire_date;

-- 12. QUERY TO DISPLAY HIGHEST, LOWEST, SUM, AVERAGE SALARY OF ALL EMPLOYEES.--
-- LABELLED AS "Maximum", "Minimum", "Sum", "Average". --
select max(salary) as "Maximum", min(salary) as "Minimum", sum(salary) as "Sum", avg(salary) as "Average"
from EMPLOYEES;

-- 13. MODIFY THE ABOVE QUERY TO DISPLAY THE SAME DATA FOR EACH JOB TYPE --
select job_id, max(salary) as "Maximum", min(salary) as "Minimum", sum(salary) as "Sum", avg(salary) as "Average"
from EMPLOYEES
group by job_id;

-- 14. QUERY TO DISPLAY THE NUMBER OR PEOPLE WITH THE SAME JOB --
select job_id, count(employee_id) as "Number of employees"
from EMPLOYEES
group by job_id;

-- 15. QUERY TO DISPLAY THE NUMBER OF MANAGERS WITHOUT LISTING THEM. --
-- LABEL THE COLUMN AS "Number of Managers" --
select count(distinct(manager_id)) as "Number of Managers"
from EMPLOYEES;

-- 16. QUERY TO DISPLAY THE DIFFERENCE BETWEEN HIGHEST AND LOWEST SALARIES. --
-- LABEL THE COLUMN AS "Difference". --
select (max(salary)-min(salary)) as "Difference"
from EMPLOYEES;

-- 17.QUERY TO DISPLAY THE ManagerNumber AND THE Salary OF THE LOWEST PAID EMPLOYEE FOR THAT MANAGER. --
-- EXCLUDE ANYONE WHOSE MANAGER IS UNKNOWN --
-- EXCLUDE ANY GROUP WHERE THE MINIMUM SALARY IS LESS THAN $6000. --
-- SORT THE OUTPUT IN DESCENDING ORDER OF SALARY --
select manager_id, min(salary)
from EMPLOYEES
where manager_id is not null
group by manager_id
order by min(salary) desc;

-- 18. QUERY TO DISPLAY EACH DepartmentsName, Location, NumberOfEmployees, AverageSalary FOR ALL THE EMPLOYEES IN THAT DEPARTMENT.--
-- LABEL THE COLUMNS AS "Name", "Location", "No.of.People", "Salary" --
-- ROUND THE AVERAGE TO TWO DECIMAL PLACES. --
select dept.department_name as "Name", dept.location_id as "Location", count(emp.employee_id) as "No.of.People",
round(avg(emp.salary),2) as "Salary"
from DEPARTMENTS as dept
join EMPLOYEES as emp
on dept.department_id = emp.department_id
group by emp.department_id;

-- 19. QUERY TO DISPLAY LastName, HireDate OF ANY EMPLOYEE IN THE DEPARTMENT AS THE EMPLOYEE "Zlotkey". --
-- EXCLUDE "Zlotkey". --
select last_name, hire_date 
from EMPLOYEES
where department_id in (select department_id from EMPLOYEES where last_name="Zlotkey")
and last_name != "Zlotkey";

-- 20. QUERY TO DISPLAY THE EmployeeNumber, LastName OF ALL EMPLOYEES WHO EARN MORE THAN THE AVERAGE SALARY. --
-- SORT THE RESULT IN ASCENDING ORDER OF SALARY. --
select employee_id, last_name 
from EMPLOYEES
where salary > (select avg(salary) from EMPLOYEES)
order by salary;

-- 21. QUERY TO DISPLAY THE EmployeeNumber, LastName OF ALL EMPLOYEES--
-- EMPLOYEES WHO WORK IN A DEPARTMENT WITH ANY EMPLOYEE WHOSE LASTNAME CONTAINS A "u".--
select employee_id, last_name
from EMPLOYEES
where department_id in (select department_id from EMPLOYEES where last_name like "%u%");

-- 22.QUERY TO DISPLAY THE LastName, DepartmentNumber, JobId OF EMPLOYEES WHOSE DEPARTMENT LOCATION_ID IS 1700 --
select last_name, department_id
from EMPLOYEES 
where department_id in (select department_id from DEPARTMENTS where location_id = 1700);

-- 23. DISPLAY THE LastName, Salary OF EVERY EMPLOYEE WHO REPORTS TO "King" --
select last_name, salary
from EMPLOYEES
where manager_id in (select employee_id from EMPLOYEES where last_name ="King");

-- 24. QUERY TO DISPLAY THE DepartmentNumber, LastName, JobId FOR EVERY EMPLOYEE IN THE "Executive" DEPARTMENT. --
select department_id, last_name, job_id
from EMPLOYEES
where department_id in (select department_id from DEPARTMENTS where department_name = "Executive");

-- 25. QUERY TO DISPLAY EmployeeNumber, LastName, Salary OF ALL EMPLOYEES WHO EARN MORE THAN THE AVERAGE SALARY--
-- AND WORK IN A DEPARTMENT WITH ANY EMPLOYEE WITH A "u" IN THEIR LASTNAME. -- 
select employee_id, last_name, salary
from EMPLOYEES
where salary > (select avg(salary) from EMPLOYEES)
and department_id in (select department_id from EMPLOYEES where last_name like "%u%");

-- 26.QUERY TO GET UNIQUE DEPARTMENT_ID FROM EMPLOYEES TABLE. --
select distinct(department_id)
from EMPLOYEES;

-- 27. QUERY TO GET ALL EMPLOYEES DETAILS FROM THE EMPLOYEE TABLE ORDER BY FirstName DESCENDING. --
select * 
from EMPLOYEES
order by first_name desc;

-- 28. QUERY TO GET THE NAMES(First_Name, Last_Name), Salary, PF OF ALL THE EMPLOYEES --
select concat(first_name,' ',last_name) as "Name", salary, (0.15*salary) as "PF"
from EMPLOYEES;

-- 29. QUERY TO GET THE EmployeeId, NAMES(First_Name, Last_Name), Salary IN ASCENDING ORDER OF SALARY. --
select employee_id, concat(first_name,' ', last_name) as "Name", salary
from EMPLOYEES 
order by salary;

-- 30.QUERY TO GET THE TOTAL SALARIES PAYABLE TO EMPLOYEES. --
select sum(salary)
from EMPLOYEES;

-- 31. QUERY TO GET MINIMUM AND MAXIMUM SALARY FROM EMPLOYEES TABLE--
select min(salary) as "Minimum", max(salary) as "Maximum"
from EMPLOYEES;

-- 32. QUERY TO GET THE AVERAGE SALARY AND NUMBER OF EMPLOYEES IN THE EMPLOYEE TABLE. --
select avg(salary) as "Average Salary",count(employee_id) as "Number Of Employees"
from EMPLOYEES;

-- 33. QUERY TO GET THE NUMBER OF EMPLOYEES WORKING WITH THE COMPANY. --
select count(employee_id) as "Number of Employees" 
from EMPLOYEES;

-- 34. QUERY TO GET THE NUMBER OF JOBS AVAILABLE IN THE EMPLOYEES TABLE--
select jb.job_title, count(emp.job_id) as "Number of Jobs"
from EMPLOYEES as emp
join JOBS as jb
on emp.job_id = jb.job_id
group by emp.job_id;

-- 35. QUERY TO GET ALL FirstNames in UPPERCASE. --
select upper(first_name) as "First Name"
from EMPLOYEES;

-- 36. QUERY TO GET FIRST 3 CHARACTERS OF FirstName FROM EMPLOYEES TABLE. --
select substring(first_name, 1, 3) 
from EMPLOYEES;

-- 37. QUERY TO GET THE NAMES OF ALL EMPLOYEES. --
select concat(first_name,' ',last_name) as "Name"
from EMPLOYEES;

-- 38. QUERY TO GET FirstName BY REMOVING SPACES FROM BOTH SIDES. --
select trim(first_name) as "First Name"
from EMPLOYEES;

-- 39. QUERY TO GET THE LENGTH OF THE FULL NAME OF EMPLOYEES. --
select length(concat(first_name,' ',last_name)) as "Length"
from EMPLOYEES;

-- 40. QUERY TO CHECK FOR NUMBERS IN FirstName. --
select * 
from EMPLOYEES
where first_name REGEXP '[0-9]';

-- 41. QUERY TO SELECT FIRST 10 RECORDS FROM A TABLE.--
select * 
from EMPLOYEES
limit 10;

-- 42. QUERY TO GET MONTHLY SALARY OF EACH EMPLOYEE. --
-- ROUND THE SALARY TO 2 DECIMAL PLACES. --
select round((salary/12), 2) as "Monthly Salary"
from EMPLOYEES;

-- 43. QUERY TO DISPLAY FirstName , LastName, Salary FOR ALL EMPLOYEES--
-- WHOSE SALARY IS NOT IN RANGE $10,000 AND $15,000.--
select first_name, last_name, salary
from EMPLOYEES
where salary not between 10000 and 15000;

-- 44. QUERY TO DISPLAY THE NAME, DepartmentId OF ALL EMPLOYEES IN 30 OR 100 DEPARTMENT IN ASCENDING ORDER. --
select concat(first_name,' ',last_name) as "Name", department_id
from EMPLOYEES
where department_id = 30 or
department_id = 100;

-- 45. QUERY TO DISPLAY NAME, Salary FOR ALL EMPLOYEES--
-- WHOSE SALARY IS NOT IN RANGE 10,000 AND 15,000 --
-- AND ARE IN 30 OR 100 DEPARTMENT. --
select concat(first_name,' ',last_name) as "Name", salary
from EMPLOYEES
where salary not between 10000 and 15000
and (department_id = 30 or department_id =100);

-- 46. QUERY TO DISPLAY THE NAME, HireDate FOR ALL EMPLOYEES WHO WERE HIRED IN 1987--
select concat(first_name,' ',last_name) as "Name", hire_date
from EMPLOYEES
where hire_date like '1987%';

-- 47. QUERY TO DISPLAY THE FirstName OF EMPLOYEES WHO HAVE BOTH "b" AND "C" IN THEIR FirstName. --
select first_name 
from EMPLOYEES
where first_name like "%b%"
and first_name like "%c%";

-- 48.QUERY TO DISPLAY THE LastName, Job, Salary FOR ALL EMPLOYEES--
-- WHOSE JOB IS THAT OF A Programmer OR A Shipping Clerk--
-- AND WHOSE SALARY IS NOT EQUAL TO $4,500 OR $10,000 OR $15,000.--
select last_name, job_id, salary
from EMPLOYEES
where job_id in(select job_id from JOBS where job_title = "Programmer" or job_title = "Shipping Clerk")
and salary not in (4500, 10000, 15000);

-- 49.QUERY TO DISPLAY THE LastName WHOSE NAME HAS EXACTLY 6 CHARACTERS. --
select last_name
from EMPLOYEES
where last_name like '______';

-- 50. QUERY TO DISPLAY THE LastName OF EMPLOYEES HAVING 'e' AS THE THIRD CHARACTER. --
select last_name 
from EMPLOYEES
where last_name like '__e%';

-- 51. QUERY TO DISPLAY THE JOBS AVAILABLE IN EMPLOYEES TABLE. --
select distinct(jb.job_title) as "Available Jobs"
from EMPLOYEES as emp
join JOBS as jb
on emp.job_id = jb.job_id;

-- 52. QUERY TO GET THE NAMES(First_Name, Last_Name), Salary, PF OF ALL THE EMPLOYEES --
select concat(first_name,' ',last_name) as "Name", salary, (0.15*salary) as "PF"
from EMPLOYEES;

-- 53. QUERY TO SELECT ALL RECORDS FROM EMPLOYEES WHERE LastName IN 'BLAKE', 'SCOTT', 'KING', 'FORD'. --
select * 
from EMPLOYEES
where last_name in ('Blake', 'Scott', 'King', 'Ford');

-- 54. QUERY TO GET THE NUMBER OF JOBS AVAILABLE IN THE EMPLOYEES TABLE--
select jb.job_title, count(emp.job_id) as "Number of Jobs"
from EMPLOYEES as emp
join JOBS as jb
on emp.job_id = jb.job_id
group by emp.job_id;

-- 55. QUERY TO GET THE TOTAL SALARIES PAYABLE TO EMPLOYEES. --
select sum(salary) as "Payable"
from EMPLOYEES;

-- 56. QUERY TO GET MINIMUM SALARY FROM EMPLOYEES TABLE.--
select min(salary) as "Minimum Salary"
from EMPLOYEES;

-- 57. QUERY TO GET MAXIMUM SALARY OF AN EMPLOYEE WORKING AS A PROGRAMMER. --
select max(salary) as "Maximum Salary"
from EMPLOYEES
where job_id in(select job_id from JOBS where job_title="Programmer");

-- 58. QUERY TO GET AVERAGE SALARY OF EMPLOYEES WORKING IN 90 DEPARTMENT.--
select avg(salary) as "Average Salary", count(employee_id) as "Number of employees"
from EMPLOYEES
where department_id =90;

-- 59. QUERY TO GET HIGHEST, LOWEST, SUM, AVERAGE SALARY OF ALL EMPLOYESS. --
select max(salary) as "Highest Salary", min(salary) as "Lowest Salary", sum(salary) as "Sum", avg(salary) as "Average"
from EMPLOYEES;

-- 60. QUERY TO GET THE NUMBER OF EMPLOYEES WITH THE SAME JOB. --
select distinct(jb.job_title), count(emp.employee_id) as "Number of Employees"
from EMPLOYEES as emp
join JOBS as jb
on emp.job_id = jb.job_id
group by emp.job_id;

-- 61.QUERY TO GET THE DIFFERENCE BETWEEN THE HIGHEST AND LOWEST SALARIES.--
select (max(salary)-min(salary)) as "Difference"
from EMPLOYEES;

-- 62. QUERY TO DISPLAY THE ManagerId AND LOWEST PAID EMPLOYEE SALARY UNDER HIM. --
select manager_id, min(salary)
from EMPLOYEES
where manager_id is not null
group by manager_id;

-- 63. QUERY TO GET THE DepartmentID AND TOTAL PAYABLE SALARY IN THAT DEPARTMENT. --
select department_id, sum(salary)
from EMPLOYEES
group by department_id;

-- 64. QUERY TO GET THE AVERAGE SALARY FOR EACH JobId EXCLUDING PROGRAMMER.--
select job_id, avg(salary) as "Average"
from EMPLOYEES
where job_id not in(select job_id from JOBS where job_title="Programmer")
group by job_id;

-- 65. QUERY TO GET THE TOTAL SALARY, MAXIMUM, MINIMUM, AVERAGE SALARY OF EMPLOYEES JOB_ID WISE--
-- FOR DEPARTMENT_ID 90 ONLY --
select sum(salary) as "Total Salary", max(salary) as "Maximum Salary", 
min(salary) as "Minimum Salary", avg(salary) as "Average Salary"
from EMPLOYEES
where department_id = 90
group by job_id;

-- 66. QUERY TO GET JOB_ID, MAXIMUM SALARY FOR EMPLOYEES WHERE MAXIMUM SALARY >= 4000. --
select job_id, max(salary)
from EMPLOYEES 
group by job_id
having max(salary) >= 4000;

-- 67. QUERY TO GET THE AVERAGE SALARY FOR ALL DEPARTMENTS EMPLOYING MORE THAN 10 EMPLOYEES.--
select  department_id, avg(salary) as "Average Salary", count(*)
from EMPLOYEES
group by department_id
having count(*)>10;

-- 68. QUERY TO GET THE NAME, SALARY OF EMPLOYEES HAVING SALARY GREATER THAN EMPLOYEE WITH LASTNAME = "Bull". --
select concat_ws(' ',first_name, last_name) as "Name", salary
from EMPLOYEES
where salary > (select salary from EMPLOYEES where last_name="Bull");

-- 69. QUERY TO FIND NAME OF EMPLOYEES WORKING IN IT DEPARTMENT. --
select concat_ws(' ',first_name,last_name) as "Name"
from EMPLOYEES 
where department_id in (select department_id from DEPARTMENTS where department_name = "IT");

-- 70. QUERY TO FIND THE NAME OF EMPLOYEES WHO HAVE A MANAGER AND WORKED IN A USA BASED DEPARTMENT. --
select concat_ws(' ',first_name, last_name) as "Name" 
from EMPLOYEES
where manager_id is not null
and department_id in (select department_id from DEPARTMENTS 
where location_id in (select location_id from LOCATIONS 
where country_id = 'US'));

-- 71. QUERY TO FIND NAME OF THE EMPLOYEES WHO ARE MANAGERS. --
select concat_ws(' ',first_name,last_name) as "Name"
from EMPLOYEES 
where employee_id in (select manager_id 
from EMPLOYEES 
where manager_id is not null);

-- 72. QUERY FIND THE NAME, SALARY OF EMPLOYEES WHOSE SALARY IS GREATER THAN AVERAGE SALARY.--
select concat_ws(' ',first_namee, last_name) as "Name", salary
from EMPLOYEES
where salary > (select avg(salary) from EMPLOYEES);
