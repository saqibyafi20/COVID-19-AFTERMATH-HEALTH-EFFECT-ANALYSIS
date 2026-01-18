create database COVID
select * from post_covid

-- Total patients

SELECT COUNT(*)  AS Total_Patients FROM post_covid

-- Hospitalization_rate

SELECT 
  ROUND(SUM(Hospitalized) *100.0 / COUNT(*), 2) AS Hospitalization_Rate
  FROM post_covid

-- Average recovery days

SELECT covid_severity , AVG(Days_to_Recovery) AS Average_Recovery_Days 
FROM post_covid 
GROUP BY covid_severity
  
-- Average Fatigue level

SELECT AVG(Fatigue_level) AS Average_Fatigue_Score 
FROM post_covid

-- % of patients reporting brain_fog

SELECT 
ROUND(AVG(Brain_fog)*100,2) AS Breathing_issue_rate 
FROM post_covid


-- % of high_long_covid_risk

SELECT CONVERT(DECIMAL(5,2),SUM(CASE WHEN Long_COVID_Risk = 'High' 
THEN 1 
ELSE 0 
END) * 100.0 / COUNT(*)) AS Rate_of_high_long_covid_risk
FROM post_covid

-- Hospitalization Impact Analysis:
--How does hospitalization affect recovery time and symptom severity?

SELECT 
Hospitalized,
COUNT(*) AS Patients,
ROUND(AVG(Days_to_Recovery), 1) AS Avg_Recovery_Days,
ROUND(AVG(Fatigue_Level), 1) AS Avg_Fatigue
FROM post_covid
GROUP BY Hospitalized

-- Long COVID Risk Identification:
-- What percentage of patients are at high risk of Long COVID?

SELECT 
Long_COVID_Risk,
CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM post_covid) AS DECIMAL(5,2)) AS Percentage
FROM post_covid
GROUP BY Long_COVID_Risk;

-- Symptom Prevalence Analysis:
-- Which post-COVID symptoms are most common?

SELECT
SUM(CASE WHEN Fatigue_Level = 1 THEN 1 ELSE 0 END) AS Fatigue,
SUM(CASE WHEN Brain_Fog = 1 THEN 1 ELSE 0 END) AS Brain_Fog,
SUM(CASE WHEN Breathing_Issue = 1 THEN 1 ELSE 0 END) AS Breathing_Issue
FROM post_covid;

-- Age Group vs Recovery Pattern:
-- Does age impact recovery duration and symptom severity?

SELECT
CASE 
WHEN Age < 30 THEN 'Under 30'
WHEN Age BETWEEN 30 AND 50 THEN '30–50'
ELSE 'Above 50'
END AS Age_Group,
COUNT(*) AS Patients,
ROUND(AVG(Days_to_Recovery), 1) AS Avg_Recovery_Days
FROM post_covid
GROUP BY 
CASE 
WHEN Age < 30 THEN 'Under 30'
WHEN Age BETWEEN 30 AND 50 THEN '30–50'
ELSE 'Above 50'
END

-- Gender-Based Health Impact:
-- Are there differences in post-COVID recovery between genders?

SELECT Gender,
COUNT(*) AS Patients,
ROUND(AVG(Days_to_Recovery), 1) AS Avg_Recovery_Days,
ROUND(AVG(Fatigue_Level), 1) AS Avg_Fatigue
FROM post_covid
GROUP BY Gender;

-- Severity vs Long COVID Risk:
-- Does COVID severity increase the risk of Long COVID?

SELECT
COVID_Severity,
Long_COVID_Risk,
COUNT(*) AS Patients
FROM post_covid
GROUP BY COVID_Severity, Long_COVID_Risk;

-- Which are the top 10 patients with the longest recovery duration after COVID?

SELECT TOP 10
Age,
Gender,
COVID_Severity,
Hospitalized,
Days_to_Recovery
FROM post_covid
ORDER BY Days_to_Recovery DESC











