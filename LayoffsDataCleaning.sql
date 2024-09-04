SELECT *
FROM layoffs_raw;

# Create a copy of raw data
# Raw data should be kept incase mistakes are made to the dataset

CREATE TABLE layoffs_cleaning
LIKE layoffs_raw;
INSERT layoffs_cleaning
SELECT *
FROM layoffs_raw;

SELECT *
FROM layoffs_cleaning;


# DATA CLEANING

# Remove Duplicates

# Check if there any duplicates by assigning a 1 to each unique row
WITH duplicate_cte AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) As unique_check
FROM layoffs_cleaning
)
SELECT *
FROM duplicate_cte
WHERE unique_check > 1;

# Creating a new table with the assigned row numbers
CREATE TABLE `layoffs_cleaning2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `unique_check` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO layoffs_cleaning2
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) As unique_check
FROM layoffs_cleaning;


SELECT *
FROM layoffs_cleaning2;

# do select first to check what is being deleted
DELETE
FROM layoffs_cleaning2
WHERE unique_check > 1;
	
    
# Standarise the Data

SELECT DISTINCT company
FROM layoffs_cleaning2
ORDER BY company ASC;

UPDATE layoffs_cleaning2
SET company = TRIM(company);

SELECT DISTINCT location
FROM layoffs_cleaning2
ORDER BY location ASC;

SELECT *
FROM layoffs_cleaning2
WHERE location = 'DÃ¼sseldorf';

UPDATE layoffs_cleaning2
SET location = 'DÃsseldorf'
WHERE location = 'DÃ¼sseldorf';

SELECT DISTINCT industry
FROM layoffs_cleaning2
ORDER BY industry ASC;

SELECT *
FROM layoffs_cleaning2
WHERE industry LIKE 'http%';

SELECT *
FROM layoffs_cleaning2
WHERE company = 'eBay';

UPDATE layoffs_cleaning2
SET industry = 'Retail'
WHERE industry LIKE 'http%';

SELECT DISTINCT stage
FROM layoffs_cleaning2
ORDER BY stage ASC;

SELECT DISTINCT country
FROM layoffs_cleaning2
ORDER BY country ASC;

SELECT `date`, STR_TO_DATE(`date`, '%Y-%m-%d')
FROM layoffs_cleaning2;

UPDATE layoffs_cleaning2
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

SELECT `date`
FROM layoffs_cleaning2;

ALTER TABLE layoffs_cleaning2
MODIFY COLUMN `date` DATE;


# Null Values and Blank Values

SELECT *
FROM layoffs_cleaning2
WHERE industry is NULL
OR industry = '';

SELECT *
FROM layoffs_cleaning2
WHERE company = 'Appsmith';

UPDATE layoffs_cleaning2
SET industry = 'Data'
WHERE company = 'Appsmith';

SELECT *
FROM layoffs_cleaning2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_cleaning2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

# Remove any columns and rows

ALTER TABLE layoffs_cleaning2 
DROP COLUMN unique_check;

ALTER TABLE layoffs_cleaning2
ADD COLUMN total_laid_off_int INT;

UPDATE layoffs_cleaning2
SET total_laid_off_int = 
    CASE 
        WHEN TRIM(total_laid_off) = '' THEN NULL
        ELSE CAST(total_laid_off AS UNSIGNED)
    END;

ALTER TABLE layoffs_cleaning2
DROP COLUMN total_laid_off;

ALTER TABLE layoffs_cleaning2
CHANGE COLUMN total_laid_off_int total_laid_off INT;

# DATA CLEANED
SELECT *
FROM layoffs_cleaning2;

