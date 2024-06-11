select * from layoff;

alter table layoff alter column date set data type text using (date::text);
alter table layoff alter column id set data type numeric(50) using (id::numeric(50));
alter table layoff alter column funds_raised_millions set data type numeric(50) using (funds_raised_millions::numeric(50));
alter table layoff alter column percentage_laid_off set data type numeric(50) using (percentage_laid_off::numeric(50));

--to show all columns and their values--
select * from layoff;

/*to show the total number of companies in the dataset,total number of staff that were laid off, 
total amount raised by those companies in the period being reviewed */

select count(company) as total_company,
		sum(total_laid_off) as total_sacked,
		sum(funds_raised_millions) as total_raised
from	layoff;


--to find the duplicates in the dataset--

with duplicate_cte as 
(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY company,
 		location,
 		country,
 		industry,
 		total_laid_off,
 		percentage_laid_off,
 		date,
		funds_raised_millions) as row_num
	FROM layoff
)
select *
from duplicate_cte
where row_num > 1;

DELETE *
FROM duplicate_cte
where row_num > 1;



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



-- correction of error in the country name --
select *
from layoff
where country = 'United States.'
order by total_laid_off Desc;


UPDATE layoff
SET	country = 'United States'
where country = 'United States.';


UPDATE layoff
SET	industry = 'Cryptocurrency'
where industry LIKE 'Crypto%';

DELETE 
FROM layoff
WHERE industry = '0';

-- values for any country with the prefix 'United'--
select *
from layoff
where country LIKE 'United%';



select 	company,
		location,
		industry,
		country,
		date,
		funds_raised_millions
from	layoff
group by company,location,industry,country,date,funds_raised_millions
order by	funds_raised_millions DESC;



SELECT 	 
		max(total_laid_off) as max_sack,
		min(total_laid_off) as min_sack
FROM  	layoff


select 	l.country,
		l.industry,
		DENSE_rank () over (order by  sum(l.total_laid_off)DESC) as most_volatile_industry
from	layoff as l
group by	l.country,l.industry;



with table1 As (select 	l.company,
		l.location,
		l.industry,
		l.country,
		l.funds_raised_millions,
		dense_rank () over(partition by l.country order by l.funds_raised_millions DESC) as Highest_profit
from layoff as l
group by l.company,l.location,l.industry,l.country,l.funds_raised_millions
			   )
select *
from table1
where Highest_profit <= 2;



SELECT DISTINCT(industry) as industries,
		SUM(total_laid_off) As industry_sack,
		SUM(funds_raised_millions) AS industry_raised
FROM	layoff
GROUP BY	industries
ORDER BY industry_sack DESC;