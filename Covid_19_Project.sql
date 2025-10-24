
-- Step 1: Understanding the overall impact of Covid-19
-- Showing Total Cases, Total Deaths and Death Percentage

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_rate_percent
FROM [ServerProject1.0]..CovidDeaths$
ORDER BY date

-- Filtering for Bangladesh only

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_rate_percent
FROM [ServerProject1.0]..CovidDeaths$
WHERE location = 'Bangladesh'
ORDER BY date

-- Step 2: Identify countries with the highest infection rate compared to population
-- Showing each country's highest recorded case count and percentage of population infected

SELECT location, population, MAX(total_cases) AS highest_cases, MAX((total_cases / population) * 100) AS percent_population_infected
FROM [ServerProject1.0]..CovidDeaths$
WHERE population IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location, population
ORDER BY percent_population_infected DESC

-- Step 3: Identify countries with the highest death percentage compared to total cases
-- This helps understand where COVID-19 was most deadly

SELECT location, MAX(CAST(total_deaths AS int)) AS highest_deaths, MAX(total_cases) AS highest_cases, 
(MAX(CAST(total_deaths AS int)) * 100.0 / MAX(total_cases)) AS death_percentage
FROM [ServerProject1.0]..CovidDeaths$
WHERE total_deaths IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location
ORDER BY death_percentage DESC


-- Step 4: Identify the point in time when a specific country saw the highest death rate
-- Looking at 'Mexico' to see the results
-- Change location = 'Mexico' to any country you want to analyze

SELECT location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 AS death_rate_percent
FROM [ServerProject1.0]..CovidDeaths$
WHERE location = 'Mexico'
ORDER BY death_rate_percent DESC

-- Step 5: Global Trend Over Time
-- Summing total cases and total deaths across all locations by date
-- This gives a time series showing the worldwide progression of the pandemic

SELECT date, SUM(new_cases) AS daily_global_cases, SUM(CONVERT(int,new_deaths)) AS daily_global_deaths
FROM [ServerProject1.0]..CovidDeaths$
WHERE continent IS NOT NULL  -- Exclude summary rows like 'World' or 'International'
GROUP BY date
ORDER BY date

-- Step 6: Analyzing vaccination impact on death trends
-- Joining CovidDeaths and CovidVaccinations on location and date

SELECT d.continent, d.location, d.date, d.total_cases, d.total_deaths, v.people_vaccinated, v.people_fully_vaccinated
FROM [ServerProject1.0]..CovidDeaths$ AS d
JOIN [ServerProject1.0]..CovidVaccinations$ AS v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.location = 'India'   -- Change this to any country you want
ORDER BY d.date

-- Step 7: Compare vaccination coverage across continents
-- Showing highest recorded vaccination percentage per continent

WITH LatestPerCountry AS (
    SELECT 
        location,
        continent,
        MAX(date) AS latest_date
    FROM [ServerProject1.0]..CovidVaccinations$ AS v
    WHERE continent IS NOT NULL
    GROUP BY location, continent
)

SELECT 
    v.continent,
    AVG(CONVERT(float,v.people_vaccinated_per_hundred)) AS avg_vaccinated_percent,
    MAX(v.people_vaccinated_per_hundred) AS max_vaccinated_percent
FROM [ServerProject1.0]..CovidVaccinations$ AS v
JOIN LatestPerCountry AS l
    ON v.location = l.location
   AND v.date = l.latest_date
GROUP BY v.continent
ORDER BY avg_vaccinated_percent DESC


-- Step 8: Which continent had the highest COVID-19 death rate overall?

WITH LatestPerCountry AS (
    SELECT 
        location,
        continent,
        MAX(date) AS latest_date
    FROM [ServerProject1.0]..CovidDeaths$ AS d
    GROUP BY location, continent
)

SELECT 
    d.continent,
    SUM(CAST(d.total_deaths AS int)) AS total_deaths,
    SUM(d.total_cases) AS total_cases,
    (SUM(CAST(d.total_deaths AS int)) / SUM(d.total_cases)) * 100.0 AS death_rate_percent
FROM [ServerProject1.0]..CovidDeaths$ AS d
JOIN LatestPerCountry AS l
    ON d.location = l.location
   AND d.date = l.latest_date
WHERE d.continent IS NOT NULL
GROUP BY d.continent
ORDER BY death_rate_percent DESC
