--to show all columns and their values--
select * from layoff;




-- correction of error in the country name --
select *
from layoff
where country = 'United States.'
order by total_laid_off Desc;


UPDATE layoff
SET	country = 'United States'
where country = 'United States.';



-- values for any country with the prefix 'United'--
select *
from layoff
where country LIKE 'United%';




-- correction of error in the wrong industry spelling --
UPDATE layoff
SET	industry = 'Cryptocurrency'
where industry LIKE 'Crypto%';



-- remove wrongly entered industry within the data--
DELETE 
FROM layoff
WHERE industry = '0';




/*to show the total number of companies in the dataset,total number of staff that were laid off, 
total amount raised by those companies in the period being reviewed */

select count(company) as total_company,
		sum(total_laid_off) as total_sacked,
		sum(funds_raised_millions) as total_raised
from	layoff;




--Top 10 companies that with the highest number of staff laid off-- 
select company,
		location,
		total_laid_off
from	layoff
order by total_laid_off desc
limit 10;




-- rank of companies per country in terms of total number of staff laid off--
select 	l.company,
		l.location,
		l.industry,
		l.country,
		l.total_laid_off,
		dense_rank () over(partition by l.country order by l.total_laid_off DESC) as Highest_layoff
from layoff as l
group by l.company,l.location,l.industry,l. country,l.total_laid_off;







-- Top company per country in terms of total number of staff laid off--
with table1 As (select 	l.company,
		l.location,
		l.industry,
		l.country,
		l.total_laid_off,
		dense_rank () over(partition by l.country order by l.total_laid_off DESC) as Highest_layoff
from layoff as l
group by l.company,l.location,l.industry,l. country,l.total_laid_off
			   )
select *
from table1
where Highest_layoff <= 1;




-- values for any country with the prefix 'United'--
select *
from layoff
where country LIKE 'United%';





--Total funds raised by each company --
select 	company,
		location,
		industry,
		country,
		funds_raised_millions
from	layoff
group by company,location,industry,country,funds_raised_millions
order by funds_raised_millions DESC;





--the ranks of industry volatility  in terms of staff layoff --
select 	l.country,
		l.industry,
		DENSE_rank () over (order by  sum(l.total_laid_off)DESC) as most_volatile_industry
from	layoff as l
group by	l.country,l.industry;






--top 2 companies per country in terms of the funds_raised--
WITH table1 AS (SELECT 	l.company,
		l.location,
		l.industry,
		l.country,
		l.funds_raised_millions,
		DENSE_RANK () OVER (PARTITION BY l.country ORDER BY l.funds_raised_millions DESC) AS Highest_profit
FROM layoff as l
GROUP BY l.company,l.location,l.industry,l.country,l.funds_raised_millions 
			   )
SELECT *
FROM table1
WHERE Highest_profit <= 2;





-- Total staff layoff and raised funds by industry
SELECT DISTINCT(industry) as industries,
		SUM(total_laid_off) As industry_sack,
		SUM(funds_raised_millions) AS industry_raised
FROM	layoff
GROUP BY	industries
ORDER BY industry_sack DESC;