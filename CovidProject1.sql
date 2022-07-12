
Create database SQLProjectDB
GO
--
Use SQLProjectDB
GO
/*
Select * From SQLProjectDB..CovidDeaths
order by 3,4

Select * From SQLProjectDB..CovidVaccinations
order by 3,4
*/

--select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2


-- looking at total cases vs total deaths
--this will show what percentage of population got covid
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From CovidDeaths
where location like '%states%'
order by 1,2

-- looking at total cases vs population

select location, date, total_cases, population, convert(decimal(5,2), (total_cases/population))*100 AS DeathPercentage
From CovidDeaths
where location like '%states%'
order by 1,2

-- looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) AS HighestInfectioncount, Max(convert(decimal(5,2), (total_cases/population)))*100 AS PercentpopulationInfected
From CovidDeaths
where location like '%states%'
Group by location, population
order by 1,2


select location, population, MAX(total_cases) AS HighestInfectioncount, Max(convert(decimal(5,2), (total_cases/population)))*100 AS PercentpopulationInfected
From CovidDeaths
--where location like '%states%'
Group by location, population
order by PercentpopulationInfected desc

-- this will show the countries with the highest death count per population

select location,  MAX(cast(total_deaths as int)) AS TotalDeathCount
From CovidDeaths
--where location like '%states%'
where continent is null
Group by location
order by TotalDeathCount desc

-- let's break things down by continent

select continent,  MAX(cast(total_deaths as int)) AS TotalDeathCount
From CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Breaking down the Global numbers

select date,	SUM(new_cases) as totalNewCases, SUM(cast(new_deaths As INT)) as totalNewDeaths, 
				SUM(cast(new_deaths AS INT))/Sum(new_cases)*100 AS DeathPercentage
From CovidDeaths
--where location like '%states%'
where continent is not null
group by date 
order by 1,2


-- let see join the tables and see what we can do. 

Select * from [dbo].[CovidDeaths] Dea
JOin [dbo].[CovidVaccinations] Vac
	on dea.location = vac.location
	and dea.date = vac.date

--looking at total population vs Vaccinations

Select dea.continent, Dea.location, dea.date, dea.population, vac.new_vaccinations
from [dbo].[CovidDeaths] Dea
JOin [dbo].[CovidVaccinations] Vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and Vac.new_vaccinations is not null
order by 2,3
-----------------------------------------------------------------------------------
-- USE CTE
WITH DeathVSvac (continent, location, date, population, new_vaccinations)
As
(
Select dea.continent, Dea.location, dea.date, dea.population, vac.new_vaccinations
from [dbo].[CovidDeaths] Dea
JOin [dbo].[CovidVaccinations] Vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

Select * from DeathVSvac
where location = 'Ethiopia' and new_vaccinations is not null
order by 1,2


-- lets create a view table to store data for later visualizarion

create view TotalDeathbyContinent
AS
(
select continent,  MAX(cast(total_deaths as int)) AS TotalDeathCount
From CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
--order by TotalDeathCount desc
)
GO
SElect * from [dbo].[TotalDeathbyContinent]




