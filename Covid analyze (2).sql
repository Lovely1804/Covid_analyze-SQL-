--"Retrieve all columns and all rows from the Excel data that was imported into the SQL table "

select * from [Covid Data ].dbo.CovidDeaths
order by 3,4


-- Selecting the data which i wanna work


select location, date, total_cases, new_cases, total_deaths, population
from [Covid Data ].dbo.CovidDeaths
order by 1,2


-- To take the out of the perc of the death in every country  or a single country

SELECT 
  location,
  date,
  TRY_CAST(total_cases AS FLOAT) AS total_cases,
  TRY_CAST(total_deaths AS FLOAT) AS total_deaths,
  CAST((TRY_CAST(total_deaths AS FLOAT) * 100.0) / NULLIF(TRY_CAST(total_cases AS FLOAT), 0) AS DECIMAL(5,2)) 
  AS Death_perc
FROM [Covid Data ].dbo.CovidDeaths
WHERE 
  TRY_CAST(total_cases AS FLOAT) IS NOT NULL
  AND TRY_CAST(total_deaths AS FLOAT) IS NOT NULL
  AND TRY_CAST(total_cases AS FLOAT) != 0
  AND TRY_CAST(total_deaths AS FLOAT) <= TRY_CAST(total_cases AS FLOAT)

-- to take the out the perc of the death in a single country

select
    location,
    date,
    Try_cast(total_cases as float) as total_cases,
    try_cast(total_deaths as float) as total_deaths,
    cast((Try_cast(total_deaths as Float) *100.0 ) / NULLIF(TRY_CAST(total_cases as float),0) as decimal(5,2))
    as Death_perc
    from [Covid Data ].dbo.CovidDeaths
    where location = 'India'

--to check the dtypes of the table CovidDeaths

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH 
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CovidDeaths'


--To check the dtypes of the table CovidDeaths

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH 
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'Covid_vact'
    and TABLE_SCHEMA ='dbo'


-- To analyze total cases in relation to the population

SELECT 
  location,
  date,
  TRY_CAST(total_cases AS FLOAT) AS total_cases,
  TRY_CAST(population AS FLOAT) AS population,
  CAST(
    (TRY_CAST(total_cases AS FLOAT) * 100.0) / NULLIF(TRY_CAST(population AS FLOAT), 0)
    AS DECIMAL(6,2)
  ) AS population_perc
FROM [Covid Data ].dbo.CovidDeaths
WHERE 
  TRY_CAST(total_cases AS FLOAT) IS NOT NULL AND 
  TRY_CAST(population AS FLOAT) IS NOT NULL AND 
  TRY_CAST(population AS FLOAT) != 0
ORDER BY 1, 2


-- To analyze total cases in relation to the population fro a particular single city

select
    location,
    date,
    Try_cast(total_cases as float) as total_cases,
    try_cast(population as float) as population,
    cast((Try_cast(total_cases as Float) *100.0 ) / NULLIF(TRY_CAST(population as float),0) as decimal(5,2))
    as population_perc
    from [Covid Data ].dbo.CovidDeaths
    where location = 'India'


-- to check the highest infectio rate  compared to population

SELECT 
  location,
  TRY_CAST(population AS FLOAT) AS population,
  MAX(TRY_CAST(total_cases AS FLOAT)) AS total_cases,
  CAST(
    MAX(TRY_CAST(total_cases AS FLOAT)) * 100.0 / NULLIF(TRY_CAST(population AS FLOAT), 0)
    AS DECIMAL(6,2)
  ) AS perc_infected
FROM [Covid Data ].dbo.CovidDeaths
WHERE 
  TRY_CAST(total_cases AS FLOAT) IS NOT NULL AND 
  TRY_CAST(population AS FLOAT) IS NOT NULL AND 
  TRY_CAST(population AS FLOAT) != 0
GROUP BY location, population
ORDER BY perc_infected DESC


-- To analyze the death per population

select
    location,MAX(cast(total_deaths as int)) as total_count
    from [Covid Data ].dbo.CovidDeaths
    where continent is not null
    group by location
    order by total_count desc


-- To analyze the death per continent

select
    continent,MAX(cast(total_deaths as int)) as total_count
    from [Covid Data ].dbo.CovidDeaths
    where continent is not null
    group by continent
    order by total_count desc


--To analyze the death perc through location

select
    location,MAX(cast(total_deaths as int)) as total_count
    from [Covid Data ].dbo.CovidDeaths
    where continent is null
    group by location
    order by total_count desc


-- Analyizing the total new_case and total new_deaths throught the date

select 
    date,
    sum(new_cases) as total_cases,
    sum(cast(new_deaths as int)) as New_deaths,
    sum(cast(new_deaths as int)) / SUM (new_cases) *100 as Death_perc
    from [Covid Data ].dbo.CovidDeaths
    where continent is not null
    group by date
    order by 1,2



-- Analyizing the total new_case and total new_deaths

select 
    sum(new_cases) as total_cases,
    sum(cast(new_deaths as int)) as New_deaths,
    sum(cast(new_deaths as int)) / SUM (new_cases) *100 as Death_perc
    from [Covid Data ].dbo.CovidDeaths
    where continent is not null
    order by 1,2


-- moving on to the next dataset (Covid_vact)

select * from [Covid Data ].dbo.Covid_vact

--Joining the two table based on location and date

select *
from [Covid Data ].dbo.CovidDeaths dea
join [Covid Data ].dbo.Covid_vact vac
on dea.location = vac.location
and dea.date = vac.date

-- Joining the table based on Population vs vacation

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
from [Covid Data ].dbo.CovidDeaths dea
join [Covid Data ].dbo.Covid_vact vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
order by 1,2,3

-- Anylazing the total sum of vacation on each location

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by  dea.location,dea.Date) as Total_new_vac
from [Covid Data ].dbo.CovidDeaths dea
join [Covid Data ].dbo.Covid_vact vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
order by 1,2,3

-- using cte to check Total_new_vacc perc

with Vacc (continent,location,date,population,new_vaccinations,Total_new_vac)
as
(
    select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by  dea.location,dea.Date) as Total_new_vac
from [Covid Data ].dbo.CovidDeaths dea
join [Covid Data ].dbo.Covid_vact vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null

)


-- to take out the sum of the total_new_vac and population

select * , (Total_new_vac/population) * 100 as new_vacc_total
from Vacc


-- Temp Table

Drop Table if exists NewVaccination_Stats
create Table NewVaccination_Stats
(
continent varchar(250),
location varchar(250),
Date datetime,
population numeric,
new_vaccinations numeric,
Total_new_vac int

)

insert into NewVaccination_Stats
  select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by  dea.location,dea.Date) as Total_new_vac
from [Covid Data ].dbo.CovidDeaths dea
join [Covid Data ].dbo.Covid_vact vac
on dea.location = vac.location
and dea.date =vac.date

select * ,(Total_new_vac/population) * 100 as new_vacc_total
from NewVaccination_Stats

--creating a view

CREATE VIEW Vaccination_Stats AS
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population, 
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Total_new_vac
FROM [Covid Data ].dbo.CovidDeaths dea
JOIN [Covid Data ].dbo.Covid_vact vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;



