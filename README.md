## COVID-19 Data Analysis Using SQL

### Overview
This project is a structured SQL-based analysis of global COVID-19 data. It focuses on deriving meaningful insights and collecting KPIs from pandemic-related datasets. The data was originally in Excel format and imported into SQL Server for analysis.

### Objectives
- Analyze COVID-19 trends by country and continent  
- Calculate KPIs such as:
  - Total Cases  
  - Total Deaths  
  - Death Percentage (Deaths vs. Cases)  
  - Infection Rate (Cases vs. Population)  
  - Vaccination Coverage  
- Use SQL to transform and explore raw data into valuable metrics

### Datasets Used
- CovidDeaths: Includes columns like location, date, total cases, new cases, total deaths, population, and more  
- CovidVaccinations: Includes daily and cumulative vaccination data by location and date

### KPIs Collected
- Death Rate (%): (Total Deaths / Total Cases) × 100  
- Infection Rate (%): (Total Cases / Population) × 100  
- Vaccination Percentage: (Total Vaccinations / Population) × 100  
- Daily New Cases and Deaths
- Cumulative Vaccination Over Time

### SQL Concepts Used
- SELECT, WHERE, ORDER BY for filtering and sorting  
- TRY_CAST, NULLIF for safe type conversion  
- SUM(), MAX() for aggregation  
- JOIN to merge death and vaccination data  
- OVER(PARTITION BY ...) for windowed calculations  
- VIEW creation for reusable summaries
