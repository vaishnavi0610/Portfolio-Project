-- data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from ['owid-covid-death']
order by 1,2;

-- looking at total cases vs total deaths (total % of deaths)
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from ['owid-covid-death'] 
order by 1,2;

-- percentage_of_death in India
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from ['owid-covid-death']
where location like 'india%'
order by 1,2;

-- percentage of death everyday
select location, date, new_cases,new_deaths,
case
when (new_cases >0) 
then (new_deaths/(cast(new_cases as float))*100)
else 0
end
from ['owid-covid-death']
-where location = 'india'
order by location, date;


-- percentage of deaths everyday for india
select location, date, new_cases,new_deaths,
case
when (new_cases>0) 
then ((new_deaths/new_cases)*100) 
else 0
end
from ['owid-covid-death']
where location = 'India'
order by date;

-- looking at total cases vs population
select location, date, total_cases, population, (total_cases/population)*100 as percentage_of_people_affected
from ['owid-covid-death'] 
where location = 'India'
order by 1,2;

--searching for country with highest infection rate compared to population
select location, max(total_cases) as maximum_total_case, population,((max(total_cases))/population)*100 as HighestPopulationInfected
from ['owid-covid-death']
group by location, population
order by HighestPopulationInfected desc;

--searching for country with highest death rate compared to population
select location, max(cast(total_deaths as int)) as maximum_total_case, population,((max(cast(total_deaths as int)))/population)*100 as HighestPopulationMortality
from ['owid-covid-death']
--where continent is not null --we are putting this condition here because data for total continents is also given
group by location, population
order by HighestPopulationMortality desc;


--looking for country with highest number of critical cases
select location, (sum(cast(icu_patients as int))/max(total_cases))*100 as Percentage_of_critical_cases
from ['owid-covid-death']
group by location
order by Percentage_of_critical_cases desc;
  

--looking at death counts
select location, max(cast(total_deaths as int)) as totaldeathcount
from ['owid-covid-death']
--where continent is null
group by location
order by totaldeathcount desc;

-- looking at death counts by continents

select continent, sum(cast(new_deaths as int)) as totaldeathcount
from ['owid-covid-death']
--where continent = 'North America'
group by continent 
order by totaldeathcount desc;

select continent, SUM(population) over (partition by continent)
from ['owid-covid-death']
where population IN(
select max(population)
from ['owid-covid-death']
group by location
)
group by continent


-- death rate in continents
select continent, sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_death, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathRateContinent
from ['owid-covid-death']
group by continent
order by DeathRateContinent;

select*
from ['owid-covid-vaccination']
order by location;

-- joining deaths and vaccination tables
select*
from ['owid-covid-death']
join ['owid-covid-vaccination']
on ['owid-covid-death'].location = ['owid-covid-vaccination'].location
   and ['owid-covid-death'].date = ['owid-covid-vaccination'].date
   order by ['owid-covid-death'].continent ;

   -- looking at total population fully vaccinated 

select ['owid-covid-death'].location,
max(cast(['owid-covid-vaccination'].people_fully_vaccinated as float))/max(['owid-covid-death'].population)*100 as FullyVaccinated
from ['owid-covid-death'] 
join ['owid-covid-vaccination']
on ['owid-covid-death'].location = ['owid-covid-vaccination'].location
   and ['owid-covid-death'].date = ['owid-covid-vaccination'].date
   where ['owid-covid-death'].location = 'india'
   group by ['owid-covid-death'].location
   order by FullyVaccinated desc;

   -- looking at tests per confirmed case inverse of positivity rate
select ['owid-covid-death'].location, ['owid-covid-death'].date, new_cases,
cast(new_tests as int),
case 
when((new_cases/(cast(new_tests as int))) > 0 )
then (1/(new_cases/(cast(new_tests as int))))
else 0
end
from ['owid-covid-vaccination']
join ['owid-covid-death']
on ['owid-covid-death'].date = ['owid-covid-vaccination'].date
and ['owid-covid-death'].location = ['owid-covid-vaccination'].location
--where ['owid-covid-death'].location = 'india' 



-- looking at total population vs total vaccination having atleast one shot using cte

with Percentage_population_vaccinated(location, date, population, new_vaccinations, Total_vaccinated)
as
(
select ['owid-covid-death'].location, ['owid-covid-death'].date, population, ['owid-covid-vaccination'].new_vaccinations, 
sum(cast(new_vaccinations as int))over (partition by ['owid-covid-death'].location order by ['owid-covid-death'].date)as 
Total_vaccinated
from ['owid-covid-death']
join ['owid-covid-vaccination']
on  ['owid-covid-death'].date = ['owid-covid-vaccination'].date
and ['owid-covid-death'].location = ['owid-covid-vaccination'].location
--order by 1,2
)
select *,(Total_vaccinated/population)*100
from Percentage_population_vaccinated;


-- ANOTHER WAY looking at total population vs total vaccination having atleast one shot using cte
select ['owid-covid-death'].location, (sum(cast(new_vaccinations as int))/max(population))*100 as Percentage_of_critical_cases
from ['owid-covid-death'] 
join ['owid-covid-vaccination'] 
on  ['owid-covid-death'].date = ['owid-covid-vaccination'].date
and ['owid-covid-death'].location = ['owid-covid-vaccination'].location
group by ['owid-covid-death'].location
order by Percentage_of_critical_cases desc;


select*
from ['owid-covid-vaccination']
where location = 'india'
order by location, date

--For visualization

select sum(cast (new_cases as int)) as total_cases, sum(cast (new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as TotalDeathRate
from ['owid-covid-death'] 
where continent is not null
order by 1,2;

-- death rate in continents
select continent, sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_death, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathRateContinent
from ['owid-covid-death']
group by continent
order by DeathRateContinent;

-- total percentage affected
select location, max(total_cases) as maximum_total_case, population,((max(total_cases))/population)*100 as HighestPopulationInfected
from ['owid-covid-death']
group by location, population
order by HighestPopulationInfected desc;

-- time series
select location, cast(date as DATE) , total_cases, population,(total_cases/population)*100 as Percentage_of_Population_Infected
from ['owid-covid-death']
group by location, population, date, total_cases

--order by Percentage_of_Population_Infected;