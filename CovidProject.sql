Select * 
From coviddeaths;

Select *
From covidvaccinations;

-- Chagne Date Column Format --
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') AS date_f
FROM coviddeaths;

Update coviddeaths
Set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

Alter Table coviddeaths
Modify Column `date` Date;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') AS date_f
FROM covidvaccinations;

Update covidvaccinations
Set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

Alter Table covidvaccinations
Modify Column `date` Date;

-- Select Data I am Going to Use --
Select location, `date`, total_cases, new_cases, total_deaths, population
From coviddeaths
Where continent is not null
order by 1,2;

-- Total Cases vs Total Deaths --
-- Shows likelihood of death if you contract covid --
Select location, `date`, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From coviddeaths
Where continent is not null
-- Where location like '%Canada%'
order by 1,2;

-- Total Cases vs Population --
Select location, `date`, total_cases, population, (total_cases/population)*100 as infection_percentage 
From coviddeaths
Where continent is not null
-- Where location like '%Canada%'
order by 1,2;

-- Infection Rate Compared to Population
Select location, population, 
Max(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as infection_percentage 
From coviddeaths
Where continent != ''
group by location, population
order by 4 Desc;

-- Countries with the Highest Death Count --
Select location,
Max(Cast(total_deaths as signed)) as TotalDeathCount
From coviddeaths
Where continent != ''
group by location
order by TotalDeathCount Desc;

-- By Continent --
Select continent,
Max(Cast(total_deaths as signed)) as TotalDeathCount
From coviddeaths
Where continent != ''
group by continent
order by TotalDeathCount Desc;

-- Global Numbers --
Select `date`, sum(new_cases) as total_cases, 
sum(cast(new_deaths as signed)) as total_deaths, 
sum(cast(new_deaths as signed))/sum(new_cases)*100 as death_percentage
From coviddeaths
Where continent != ''
group by `date`
order by 1,2;

Select sum(new_cases) as total_cases, 
sum(cast(new_deaths as signed)) as total_deaths, 
sum(cast(new_deaths as signed))/sum(new_cases)*100 as death_percentage
From coviddeaths
Where continent != ''
order by 1,2;

-- Join Covid Vaccinations -- 
Select *
From coviddeaths as dea
Join covidvaccinations as vac
	On dea.location = vac.location 
    and dea.`date` = vac.`date`
Where dea.location = 'Albania';

-- Total Population vs Vaccination --
Select dea.continent, dea.location, dea.`date`, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as signed))
Over(Partition by dea.location order by dea.location, dea.`date`) as Rolling_VaccinationCount
From coviddeaths as dea
Join covidvaccinations as vac
	On dea.location = vac.location 
    and dea.`date` = vac.`date`
Where dea.continent != ''
order by 2,3;

-- Use CTE --
With PopvsVac (Continent, Location, `Date`, Population, New_Vaccinations, Rolling_VaccinationCount) as 
(
Select dea.continent, dea.location, dea.`date`, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as signed))
Over(Partition by dea.location order by dea.location, dea.`date`) as Rolling_VaccinationCount
From coviddeaths as dea
Join covidvaccinations as vac
	On dea.location = vac.location 
    and dea.`date` = vac.`date`
Where dea.continent != ''
)
Select *, (Rolling_VaccinationCount/Population)*100 as PercentVaccinated
From PopvsVac;

-- Temp Table --
Drop Table if exists PercentPopVaccinated;
Create Temporary Table PercentPopVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
`Date` datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_VaccinationCount numeric
);

Insert into PercentPopVaccinated
Select dea.continent, dea.location, dea.`date`, dea.population, 
       NULLIF(vac.new_vaccinations, '') AS New_Vaccinations,  -- Convert '' to NULL
       Sum(CAST(NULLIF(vac.new_vaccinations, '') AS SIGNED)) 
       Over(Partition by dea.location order by dea.location, dea.`date`) as Rolling_VaccinationCount
From coviddeaths as dea
Join covidvaccinations as vac
    On dea.location = vac.location 
    And dea.`date` = vac.`date`
Where dea.continent <> '';

Select *, (Rolling_VaccinationCount/Population)*100 as PercentVaccinated
From PercentPopVaccinated;

-- Create View to Store Data for Visualization --

Create View PercentPopVaccinated as
Select dea.continent, dea.location, dea.`date`, dea.population, 
       NULLIF(vac.new_vaccinations, '') AS New_Vaccinations,  -- Convert '' to NULL
       Sum(CAST(NULLIF(vac.new_vaccinations, '') AS SIGNED)) 
       Over(Partition by dea.location order by dea.location, dea.`date`) as Rolling_VaccinationCount
From coviddeaths as dea
Join covidvaccinations as vac
    On dea.location = vac.location 
    And dea.`date` = vac.`date`
Where dea.continent <> ''
;