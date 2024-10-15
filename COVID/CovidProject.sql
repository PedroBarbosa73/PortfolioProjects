
--Covid 19 Data Exploration 

--Skills used:  Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types, Stored Procedure




SELECT *
FROM CovidDeaths
WHERE continent is not NULL --- Null countries are Continents in the data


-- Select Data that we are going to be starting with

SELECT location , date , total_cases , new_cases , total_deaths , population 
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country


SELECT Location,
       --date AS 'Date',
	   total_deaths AS 'Total Deaths',
	   total_cases as 'Total Cases',
       (total_deaths / NULLIF(total_cases, 0)) * 100 AS 'Death Percentage'
FROM CovidDeaths
WHERE continent is not NULL AND date= '2024-06-19'
ORDER BY [Death Percentage] DESC



EXEC LikelihoodOfDying

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
-- Countries with Highest Infection Rate compared to Population




	    SELECT 
        --date AS 'Date',
        Location,
        Population,
        total_deaths AS 'Total Deaths',
        total_cases AS 'Total Cases',
        (total_cases / population) * 100 AS 'Contamination Percentage',
        (total_deaths / population) * 100 AS 'Death Percentage'
    FROM 
        CovidDeaths
		WHERE date ='2024-06-19'
		ORDER BY [Contamination Percentage]DESC


-- Countries with Highest Death Count per Population





-- Showing contintents with the highest death count per population
 

 
 SELECT continent,
		Max(total_deaths) AS 'TOTAL DEATHS'
		FROM CovidDeaths
 WHERE continent is not null
 GROUP BY continent
 ORDER BY [TOTAL DEATHS]DESC






-- GLOBAL NUMBERS

SELECT location,
	   population,
	   MAX(total_cases) AS 'Total Cases',
	   MAX(total_deaths) AS 'Total Deaths',
	   (MAX(total_cases)/population) AS 'Percentage of contaminated population',
	   (MAX(total_deaths)/population) AS 'Percentage of deaths '
FROM CovidDeaths
WHERE location LIKE  'World'
GROUP BY  location , population

-- GLOBAL NUMBERS BY DATE

SELECT date,
	location,
	   population,
	   MAX(total_cases) AS 'Total Cases',
	   MAX(total_deaths) AS 'Total Deaths',
	   (total_cases)/population AS 'Percentage of contaminated population',
	   (total_deaths)/population AS 'Percentage of deaths '
FROM CovidDeaths
WHERE location LIKE  'World'
GROUP BY  date,location , population , total_cases, total_deaths
ORDER BY date DESC






-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


SELECT date,
       location,
       population,
	   people_vaccinated ,
	   people_fully_vaccinated,
	   (people_vaccinated/population)*100 AS 'Pecentage of population with at least one Vaccine',
	   (people_fully_vaccinated/population)*100 AS 'Percentage of fully vaccinated population'
FROM CovidVaccines
WHERE location = 'World'-- AND date = '2024-08-14'
GROUP BY date, location, population, people_vaccinated, people_fully_vaccinated
ORDER BY [Percentage of fully vaccinated population]DESC




--CREATING TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated
(
Date datetime,
Location nvarchar(20),
Population float,
PeopleVaccinated float,
PeopleFullyVaccinated float,
PerPPLOneVac float,
PerPPLFullyVac float)

INSERT INTO #PercentPopulationVaccinated 
SELECT date,
       location,
       population,
	   people_vaccinated ,
	   people_fully_vaccinated,
	   (people_vaccinated/population)*100 AS 'Pecentage of population with at least one Vaccine',
	   (people_fully_vaccinated/population)*100 AS 'Percentage of fully vaccinated population'
FROM CovidVaccines
WHERE location = 'World' AND date = '2024-08-14'
GROUP BY date, location, population, people_vaccinated, people_fully_vaccinated

DROP TABLE IF EXISTS #PercentPopulationVaccinated 

ALTER TABLE #PercentPopulationVaccinated 
ALTER COLUMN location nvarchar(300)

SELECT *
FROM #PercentPopulationVaccinated
WHERE location = 'World'  
ORDER BY PerPPLFullyVac DESC






-- Creating View to store data for later visualizations

CREATE VIEW  WorldPercentageOfVaccination AS

SELECT date,
       location,
       population,
	   people_vaccinated ,
	   people_fully_vaccinated,
	   (people_vaccinated/population)*100 AS 'Pecentage of population with at least one Vaccine',
	   (people_fully_vaccinated/population)*100 AS 'Percentage of fully vaccinated population'
FROM CovidVaccines
WHERE location = 'World' AND date = '2024-08-14'
GROUP BY date, location, population, people_vaccinated, people_fully_vaccinated

SELECT *
FROM WorldPercentageOfVaccination


CREATE VIEW DeathPercentagePerCountry AS

SELECT Location,
	   total_deaths AS 'Total Deaths',
	   total_cases as 'Total Cases',
       (total_deaths / NULLIF(total_cases, 0)) * 100 AS 'Death Percentage'
FROM CovidDeaths
WHERE continent is not NULL AND date= '2024-06-19'

SELECT *
FROM DeathPercentagePerCountry
ORDER BY [Death Percentage]DESC

-- CREATING STORED PROCEDURE	

CREATE PROCEDURE GlobalStats AS

SELECT location,
	   population,
	   MAX(total_cases) AS 'Total Cases',
	   MAX(total_deaths) AS 'Total Deaths',
	   (MAX(total_cases)/population) AS 'Percentage of contaminated population',
	   (MAX(total_deaths)/population) AS 'Percentage of deaths '
FROM CovidDeaths
WHERE location LIKE  'World'
GROUP BY  location , population

EXEC GlobalStats


S

-- CREATING STORED PROCEDURE TO INSERT 



CREATE PROCEDURE CreateTblandPopulate5

	AS

	DROP TABLE IF EXISTS Data1


	CREATE TABLE Data1(
			[Date] DATETIME
           ,[Location] nvarchar(max)
           ,[Population] float
           ,[PeopleVaccinated] float
           ,[PeopleFullyVaccinated] float
           ,[PerPPLOneVac] float
           ,[PerPPLFullyVac] float)



INSERT INTO [dbo].Data1
            ([Date]
           ,[Location]
           ,[Population]
           ,[PeopleVaccinated]
           ,[PeopleFullyVaccinated]
           ,[PerPPLOneVac]
           ,[PerPPLFullyVac])
SELECT date,
       location,
       population,
	   people_vaccinated ,
	   people_fully_vaccinated,
	   (people_vaccinated/population)*100 AS 'percentage_vacinated',
	   (people_fully_vaccinated/population)*100 AS 'percentage_fully_vaccinated'
FROM CovidVaccines;

SELECT date,
       location,
       population,
	   people_vaccinated ,
	   people_fully_vaccinated,
	   (people_vaccinated/population)*100 AS 'percentage_vacinated',
	   (people_fully_vaccinated/population)*100 AS 'percentage_fully_vaccinated'
FROM CovidVaccines;
GO



EXEC CreateTblandPopulate5


SELECT *
FROM Data1
ORDER BY date



CREATE INDEX Ix_Date
ON CovidDeaths(date,location,total_cases)

SELECT date, location , total_cases
FROM CovidDeaths
ORDER BY date

DROP  INDEX Ix_Date ON CovidDeaths

CREATE INDEX Ix_Date2
ON Data1(date)






















---
------------
