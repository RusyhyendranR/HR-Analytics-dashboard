select * from 
hr;
alter table hr 
change column ï»¿id emp_id varchar(30) null;

SELECT birthdate from 
hr;

SET SQL_SAFE_UPDATES = 0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr
modify column birthdate date;

describe hr;


UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr
modify column hire_date date;


select hire_date 
FROM hr;

SELECT termdate FROM 
hr;

UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ' AND termdate != '';

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL OR termdate = '';
SET SQL_SAFE_UPDATES = 0;

SET sql_mode = '';
ALTER TABLE hr MODIFY COLUMN termdate DATE;

ALTER TABLE HR 
ADD column age int;

UPDATE hr 
set age = timestampdiff(year,birthdate,CURDATE());
SELECT birthdate,  age  from 
hr;
------------------
select gender,
count(*) as count
from hr
where age > 18 and termdate = 0000-00-00
group by gender;


select race, count(race) as race 
from hr 
where age >18 
group by race;

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, gender,
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group, gender
ORDER BY age_group, gender;
    
    select location, 
    count(*) as location_distribution
    from hr
    group by location;

select round(avg(datediff(termdate,hire_date))/365,0) as avg_length_of_employment
from hr
where termdate is not null
and  termdate <> 000-00-00 and termdate <= curdate() and age >= 18;

select 
jobtitle, department, gender , count(*) as count
from hr 
group by gender, department , jobtitle
order by department;

select jobtitle , count(jobtitle) as Count 
from hr
group by jobtitle
order by department;


SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> 0000-00-00 THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = 0000-00-00 THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;


select location_state , count(*) as cnt
from hr
group by location_state
order by cnt desc; 


SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> 0000-00-00 AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> 0000-00-00 AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> 0000-00-00 AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;
    
    
    
    SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> 0000-00-00 AND age >= 18
GROUP BY department