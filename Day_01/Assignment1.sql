create database assignment1;
use assignment1;
create table REGIONS(region_id int, region_name varchar(50) not null, primary key(region_id));
create table COUNTRIES(country_id varchar(4), country_name varchar(50) not null, region_id int, primary key(country_id), foreign key(region_id) references regions(region_id));
create table LOCATIONS(location_id int, street_address varchar(255), postal_code varchar(10), city varchar(50), state_province varchar(50), country_id varchar(4), primary key(location_id), foreign key(country_id) references countries(country_id));
create table DEPARTMENTS(department_id int, department_name varchar(50), manager_id int unique auto_increment, location_id int, primary key(department_id), foreign key(location_id) references locations(location_id));
create table JOBS(job_id varchar(15), job_title varchar(50), min_salary int, max_salary int, primary key(job_id));

