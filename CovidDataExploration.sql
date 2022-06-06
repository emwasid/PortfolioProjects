SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 3,4 

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4 

-- Select Data that we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at Total Cases Vs Population
--Shows what percentage of population got Covid

SELECT Location, date, population, total_cases,  (total_cases/population) * 100 AS CasePercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection rate compared to Population
SELECT Location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population)) * 100 AS PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
GROUP BY Location, population
ORDER BY PercentagePopulationInfected DESC

-- Showing Countries with Highest Death Count per Population
SELECT Location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT



-- Showing Continents with the Highest Death Count Per Population
SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY 2, 3

-- USE CTE 

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2, 3
)

SELECT  *, (RollingPeopleVaccinated/population) * 100
FROM PopvsVac


-- TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is NOT NULL
--ORDER BY 2, 3
SELECT  *, (RollingPeopleVaccinated/population) * 100
FROM #PercentPopulationVaccinated


-- Creating View to srote data for later vizualizations
CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY  dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2, 3


SELECT *
FROM PercentPopulationVaccinated