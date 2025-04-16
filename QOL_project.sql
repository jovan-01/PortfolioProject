Create Table chronic as 
Select Gender,Total_physical_act_time,Smoked,weekly_alcohol, High_BP,High_cholestrol,Diabetic
From stressdata;

Select *
From chronic;

ALTER TABLE chronic MODIFY COLUMN gender VARCHAR(10);

UPDATE chronic
SET gender = CASE
  WHEN gender = 1 THEN 'Male'
  WHEN gender = 2 THEN 'Female'
  ELSE 'Not Stated'
END;


Update chronic 
Set Total_physical_act_time = null
Where Total_physical_act_time >= 9996;

Select Total_physical_act_time 
From chronic
order by Total_physical_act_time desc;

Update chronic 
Set Smoked = null 
Where Smoked >= 996;

ALTER TABLE chronic MODIFY COLUMN Smoked VARCHAR(10);
Update chronic
Set Smoked = Case
	When Smoked >= 1 and Smoked <= 20 then '1-20'
    When Smoked > 20 and Smoked <= 40 then '21-40'
	When Smoked > 40 and Smoked <= 60 then '41-60'
    When Smoked > 60 and Smoked <= 80 then '61-80'
    Else null
End;

Select Smoked
From chronic
Order by Smoked desc;


ALTER TABLE chronic MODIFY COLUMN weekly_alcohol VARCHAR(10);
Update chronic
Set weekly_alcohol = Case
	When weekly_alcohol = 1 then 'Yes'
    When weekly_alcohol = 2 then 'No'
    Else 'Not Stated'
End;

Select weekly_alcohol
From chronic;

ALTER TABLE chronic MODIFY COLUMN High_BP VARCHAR(10);
Update chronic
Set High_BP = Case
	When High_BP = 1 then 'Yes'
    When High_BP = 2 then 'No'
    Else 'Not Stated'
End;

ALTER TABLE chronic MODIFY COLUMN High_cholestrol VARCHAR(10);
Update chronic
Set High_cholestrol = Case
	When High_cholestrol = 1 then 'Yes'
    When High_cholestrol = 2 then 'No'
    Else 'Not Stated'
End;

ALTER TABLE chronic MODIFY COLUMN Diabetic VARCHAR(10);
Update chronic
Set Diabetic = Case
	When Diabetic = 1 then 'Yes'
    When Diabetic = 2 then 'No'
    Else 'Not Stated'
End;

Select *
From chronic;

#Percent High BP by Gender
SELECT Gender,
       ROUND(SUM(CASE WHEN High_BP = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS High_BP_Rate
FROM chronic
GROUP BY Gender;

#Number of Cigarettes Smoked and Percent High BP 
SELECT Smoked, 
       ROUND(SUM(CASE WHEN High_BP = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS High_BP_Rate
FROM chronic
GROUP BY Smoked
Order by Smoked;

#Weekly Alcohol and Percent High Cholestrol
SELECT weekly_alcohol, 
       ROUND(SUM(CASE WHEN High_cholestrol = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS High_Chol_Rate
FROM chronic
GROUP BY weekly_alcohol;

#Avg Activity By Gender, Diabetic, High BP
SELECT Gender, 
       AVG(CAST(Total_physical_act_time AS UNSIGNED)) AS Avg_Activity
FROM chronic
WHERE Total_physical_act_time IS NOT NULL
GROUP BY Gender;

SELECT Diabetic, 
       AVG(CAST(Total_physical_act_time AS UNSIGNED)) AS Avg_Activity
FROM chronic
WHERE Total_physical_act_time IS NOT NULL
GROUP BY Diabetic;

SELECT High_BP, 
       AVG(CAST(Total_physical_act_time AS UNSIGNED)) AS Avg_Activity
FROM chronic
WHERE Total_physical_act_time IS NOT NULL
GROUP BY High_BP;

#Comorbitity Analysis
With CMA as 
(
SELECT COUNT(*) AS Total,
       SUM(CASE 
       WHEN High_BP = 'Yes' AND High_cholestrol = 'Yes' AND Diabetic = 'Yes' THEN 1 ELSE 0 END) 
       AS All_3_Conditions
FROM Chronic
)
Select *, Round((All_3_Conditions/Total)*100,2) as Percent_Cormobid
From CMA;

-- Mental Health --

Create table mental
Select Gender,Life_satisfaction,Mental_health_state,Stress_level,
High_BP,Fatigue_syndrome,Mood_disorder,Anxiety_disorder,Work_hours,Total_income
From stressdata;

Select * 
From mental;

ALTER TABLE mental MODIFY COLUMN gender VARCHAR(10);
UPDATE mental
SET gender = CASE
  WHEN gender = 1 THEN 'Male'
  WHEN gender = 2 THEN 'Female'
  ELSE 'Not Stated'
END;

UPDATE mental
Set Life_satisfaction = null
Where Life_satisfaction > 10;

ALTER TABLE mental MODIFY COLUMN Mental_health_state VARCHAR(10);
Update mental 
Set Mental_health_state = case
	When Mental_health_state = 1 Then 'Excellent'
    When Mental_health_state = 2 Then 'Very Good'
    When Mental_health_state = 3 Then 'Good'
    When Mental_health_state = 4 Then 'Fair'
    When Mental_health_state = 5 Then 'Poor'
    Else null
End;

ALTER TABLE mental MODIFY COLUMN Stress_level VARCHAR(50);
Update mental
Set Stress_level = case
	When Stress_level = 1 Then 'Not at all stressful'
    When Stress_level = 2 Then 'Not very stressful'
    When Stress_level = 3 Then 'A bit stressful'
    When Stress_level = 4 Then 'Quite a bit stressful'
    When Stress_level = 5 Then 'Extremely stressful'
    Else null
End;

ALTER TABLE mental MODIFY COLUMN High_BP VARCHAR(10);
Update mental
Set High_BP = Case
	When High_BP = 1 then 'Yes'
    When High_BP = 2 then 'No'
    Else 'Not Stated'
End;

ALTER TABLE mental MODIFY COLUMN Fatigue_syndrome VARCHAR(10);
Update mental
Set Fatigue_syndrome = Case
	When Fatigue_syndrome = 1 then 'Yes'
    When Fatigue_syndrome = 2 then 'No'
    When Fatigue_syndrome = 7 then "Don't Know"
    Else 'Not Stated'
End;

ALTER TABLE mental MODIFY COLUMN Mood_disorder VARCHAR(10);
Update mental
Set Mood_disorder = Case
	When Mood_disorder = 1 then 'Yes'
    When Mood_disorder = 2 then 'No'
    When Mood_disorder = 7 then "Don't Know"
    Else 'Not Stated'
End;

ALTER TABLE mental MODIFY COLUMN Anxiety_disorder VARCHAR(10);
Update mental
Set Anxiety_disorder = Case
	When Anxiety_disorder = 1 then 'Yes'
    When Anxiety_disorder = 2 then 'No'
    When Anxiety_disorder = 7 then "Don't Know"
    Else 'Not Stated'
End;

Update mental
Set Work_hours = null
Where Work_hours > 60;

ALTER TABLE mental MODIFY COLUMN Total_income VARCHAR(50);
Update mental
Set Total_income = case
	When Total_income = 1 Then '< $20,000'
    When Total_income = 2 Then '$20,000 - $39,999'
    When Total_income = 3 Then '$40,000 - $59,999'
    When Total_income = 4 Then '$60,000 - $79,999'
    When Total_income = 5 Then '> $80,000'
    Else null
End;

Select * 
From mental;

#Life Satisfaction vs Mental Health
Select AVG(Life_satisfaction) as Avg_Satisfaction, Mental_health_state
From mental
Where Mental_health_state is not null 
Group by Mental_health_state
Order by Avg_Satisfaction desc;

#Stress Level vs High BP
Select Stress_level,  ROUND(SUM(CASE WHEN High_BP = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as HighBP_Percent
From mental
Where Stress_level is not null
Group by Stress_level
Order by HighBP_Percent desc;

#Stress Level vs Anxiety
Select Stress_level, ROUND(SUM(CASE WHEN Anxiety_disorder = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as Anxiety_Percent
From mental
Where Stress_level is not null
Group by Stress_level
Order by Anxiety_Percent desc;

#Life Satisfaction vs Income
Select Total_income, AVG(Life_satisfaction) as LifeScore
From mental
Where Total_income is not null
Group by Total_income
Order by LifeScore desc;

#Works Hours By Gender
SELECT Gender, ROUND(AVG(Work_hours), 2) AS Avg_Work_Hours
FROM mental
WHERE Work_hours IS NOT NULL
GROUP BY Gender;

#Mood Disorder by Gender
SELECT 
    Gender,
    COUNT(*) AS Total_Respondents,
    SUM(CASE WHEN Mood_disorder = 'Yes' THEN 1 ELSE 0 END) AS With_Mood_Disorder,
    ROUND(SUM(CASE WHEN Mood_disorder = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Mood_Disorder_Percent
FROM mental
GROUP BY Gender;

#Anxiety by Gender
SELECT 
    Gender,
    COUNT(*) AS Total_Respondents,
    SUM(CASE WHEN Anxiety_disorder = 'Yes' THEN 1 ELSE 0 END) AS With_Anxiety,
    ROUND(SUM(CASE WHEN Anxiety_disorder = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Anxiety_Percent
FROM mental
GROUP BY Gender;

#Life Satisfaction by Gender
Select Gender, AVG(Life_satisfaction)
From mental
Where Life_satisfaction is not null
Group by Gender;

#Income by Gender
SELECT Total_income, Gender, COUNT(*) AS Respondent_Count
FROM mental
WHERE Total_income IS NOT NULL
GROUP BY Total_income, Gender
ORDER BY Gender, Respondent_Count desc;

#Stress and Mental Health
SELECT Stress_level, AVG(Life_satisfaction) AS Avg_LS
FROM mental
WHERE Mental_health_state IS NOT NULL and Stress_level is not null
GROUP BY Stress_level
Order by Avg_LS desc;

#Stress Risk Profile
SELECT 
    Gender,
    CASE 
        WHEN Stress_level IN ('Quite a bit stressful', 'Very stressful') 
             AND (`Mood_disorder` = 'Yes' OR `Anxiety_disorder` = 'Yes') 
             AND (`Total_income` = '< $20,000' OR `Total_income` = '$20,000 - $39,999')
        THEN 'High Risk'
        WHEN Stress_level IN ('A bit stressful') 
             AND (`Mood_disorder` = 'Yes' OR `Anxiety_disorder` = 'Yes') 
        THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Level,
    COUNT(*) AS People_Count
FROM mental
GROUP BY Gender, Risk_Level
ORDER BY Risk_Level;

#Multivariate Risk Profile
SELECT
    Gender,
    Stress_level,
    Mental_health_state,
    Total_income,
    -- Create a Risk Profile Label
    CASE
        WHEN Stress_level IN ('Quite a bit stressful', 'Very stressful') 
             AND Mental_health_state IN ('Poor', 'Fair')
             AND (Total_income = '< $20,000' OR Total_income = '$20,000 - $39,999')
        THEN 'High Risk'

        WHEN Stress_level IN ('A bit stressful') 
             AND Mental_health_state IN ('Fair', 'Good')
             AND (Total_income = '$40,000 - $59,999' OR Total_income = '$20,000 - $39,999')
        THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS Risk_Profile,

    COUNT(*) AS Num_Participants,
    ROUND(AVG(CAST(Work_hours AS UNSIGNED)), 1) AS Avg_Work_Hours,
    ROUND(AVG(CAST(Life_satisfaction AS UNSIGNED)), 1) AS Avg_Life_Satisfaction

FROM mental
WHERE Mental_health_state IS NOT NULL
  AND Stress_level IS NOT NULL
  AND Total_income IS NOT NULL
GROUP BY
    Gender,
    Stress_level,
    Mental_health_state,
    Total_income,
    Risk_Profile
ORDER BY Risk_Profile, Num_Participants DESC;

