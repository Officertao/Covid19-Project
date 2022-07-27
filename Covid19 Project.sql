SELECT Location,Date,Total_cases,new_cases,total_deaths,population
FROM CovidDeaths1
WHERE Continent is not Null
ORDER BY 1,2


--Death Rate Percentage.Total Death Vs Total CAses

SELECT Location,Date,Total_cases,total_deaths,(total_deaths/total_Cases)*100 AS DeathPercentage
FROM CovidDeaths1
--WHERE Location Like '%states%' AND
WHERE Continent is not Null
ORDER BY DeathPercentage DESC

--Total cases vs Population.Percentage of Population that got covid
SELECT Location,Date,Total_cases,Population,(total_Cases/population)*100 AS DeathPercentage
FROM CovidDeaths1
--WHERE Location Like '%states%'
WHERE Continent is not Null
ORDER BY DeathPercentage DESC

--Highest Infection Rate country to Population
SELECT Location,population,MAX(Total_cases),Population,MAX((total_Cases/population))*100 AS HighestInfectionRate
FROM CovidDeaths1
--WHERE Location Like '%states%'
WHERE Continent is not Null
GROUP BY Location,population
ORDER BY HighestInfectionRate DESC

--Country with HighestDeathCount per population
SELECT Location,population,MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM CovidDeaths1
WHERE Continent is not Null
GROUP BY Location,population
ORDER BY HighestDeathCount DESC

--Total DeathCount Per continent
SELECT Continent,MAX(CAST(total_deaths as int)) as ContinentDeathCount
FROM CovidDeaths1
WHERE Continent is not Null
GROUP BY Continent
ORDER BY ContinentDeathCount DESC

--Global Number
SELECT Date,SUM(new_cases) AS TotalNewCases,SUM(CAST(total_deaths as int)) AS TotalDeath, SUM(CAST(total_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths1
WHERE Continent is not Null
GROUP BY Date
ORDER BY 1,2


--Total population and Vaccination
SELECT D.continent,D.location,D.Date,D.population,V.new_vaccinations,SUM(CAST(V.new_vaccinations as int)) OVER (partition by D.location ORDER by D.location,D.Date) as RollingVaccinated
FROM CovidDeaths1 D 
 Join CovidVaccination V
ON D.location = V.location
and D.Date = V.Date
WHERE D.continent is not null
ORDER BY 2,3 DESC

--CTE
WITH POPVSVACC (continent,location,Date,population,new_vaccinations,RollingVaccinated) as
(SELECT D.continent,D.location,D.Date,D.population,V.new_vaccinations,SUM(CAST(V.new_vaccinations as int)) OVER (partition by D.location ORDER by D.location,D.Date) as RollingVaccinated
FROM CovidDeaths1 D 
 Join CovidVaccination V
ON D.location = V.location
and D.Date = V.Date
WHERE D.continent is not null
)
SELECT *,(RollingVaccinated/population)*100 as percentagevaccinated
FROM POPVSVACC

