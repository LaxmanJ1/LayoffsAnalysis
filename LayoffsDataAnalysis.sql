-- Select all columns from the layoffs_cleaning2 table
SELECT *
FROM layoffs_cleaning2;




-- Summarise total layoffs by company, ordering by the highest totals
SELECT company, SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY 2 DESC;

-- Summarise total layoffs by industry, ordering by the highest totals
SELECT industry, SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY 2 DESC;

-- Summarise total layoffs by country, ordering by the highest totals
SELECT country, SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY 2 DESC;

-- Summarise total layoffs by country and location, ordering by the highest totals
SELECT country, location, SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY country, location
ORDER BY 3 DESC;

-- Summarise total layoffs by country and industry, ordering by the highest totals
SELECT country, industry, SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY country, industry
ORDER BY 3 DESC;

-- Summarise total layoffs by company and industry, ordering by the highest totals
SELECT company, industry, SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY company, industry
ORDER BY 3 DESC;




-- Calculate the total number of layoffs across all records
SELECT SUM(total_laid_off)
FROM layoffs_cleaning2;

-- Summarise total layoffs by year, ordering by the highest totals
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaning2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- Summarise total layoffs by year, filtering for years with more than 100,000 layoffs
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaning2
GROUP BY YEAR(`date`)
HAVING SUM(total_laid_off) > 100000
ORDER BY 2 DESC;

-- Summarise total layoffs by company for the year 2023, ordering by the highest totals
SELECT company, `date`, SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
AND `date` LIKE '2023%'
GROUP BY company, `date`
ORDER BY 3 DESC;

-- Summarise total layoffs by month for the year 2023, ordering by the highest totals
SELECT MONTH(`date`), SUM(total_laid_off)
FROM layoffs_cleaning2
WHERE `date` LIKE '2023%'
GROUP BY MONTH(`date`)
ORDER BY 2 DESC;

-- Summarise total layoffs by company and year, ordering by company name and highest totals
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY company, YEAR(`date`)
ORDER BY company, 3 DESC;





-- Rank the total layoffs by company for each year, ordering by year and highest totals
SELECT company, YEAR(`date`), SUM(total_laid_off),
DENSE_RANK() OVER(partition by company ORDER BY SUM(total_laid_off) DESC) Rank_Num
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY company, YEAR(`date`)
ORDER BY 2 DESC, 3 DESC;

-- Rank the total layoffs by country for each year, ordering by year and highest totals
SELECT country, YEAR(`date`), SUM(total_laid_off),
DENSE_RANK() OVER(partition by country ORDER BY SUM(total_laid_off) DESC) Rank_Num
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY country, YEAR(`date`)
ORDER BY 2 DESC, 3 DESC;

-- Rank the total layoffs by industry for each year, ordering by year and highest totals
SELECT industry, YEAR(`date`), SUM(total_laid_off),
DENSE_RANK() OVER(partition by industry ORDER BY SUM(total_laid_off) DESC) Rank_Num
FROM layoffs_cleaning2
WHERE total_laid_off IS NOT NULL
GROUP BY industry, YEAR(`date`)
ORDER BY 2 DESC, 3 DESC;
