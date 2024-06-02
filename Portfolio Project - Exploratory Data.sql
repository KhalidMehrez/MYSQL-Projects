-- Exploratory Data Analysis

-- Here I just going to explore the data and find trends or patterns or anything interesting
-- with this info we are just going to look around and see what will find



Select *
FROM layoffs_new_staging2;


Select MAX(total_laid_off), MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM layoffs_new_staging2;

Select *
FROM layoffs_new_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Queries by using GROUP BY 

Select company, SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_new_staging2;


Select industry, SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY industry
ORDER BY 2 DESC;

Select country, SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_new_staging2;

Select YEAR(`date`) YEARD, SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY YEARD
ORDER BY 1 DESC;


Select stage, SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT company, SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;


-- Rolling total of Layoffs


SELECT *
FROM layoffs_new_staging2;

SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_new_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_new_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Companies with the most Layoffs (per year)

Select company, SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY company
ORDER BY 2 DESC;

Select company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 desc;

WITH Company_Year (company, years, total_laid_off) AS
(
Select company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_new_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5
;



