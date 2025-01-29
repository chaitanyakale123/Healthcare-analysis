use project;
select * from healthcare_data;

------------------------------------------------------------------------------------------------------------
-----average billing amount M

SELECT AVG(Billing_Amount) AS Average_Billing 
FROM healthcare_data;

-----total healthcare cost M
SELECT SUM(Billing_Amount) AS Total_Cost
FROM healthcare_data;


------Billing amounts vary by insurance provider

SELECT Insurance_Provider, AVG(Billing_Amount) AS Average_Billing
FROM healthcare_data
GROUP BY Insurance_Provider;

------total count of patients by admission type

SELECT Admission_Type, COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY Admission_Type;

------billing amounts vary by insurance provider?

SELECT Insurance_Provider, AVG(Billing_Amount) AS Average_Billing
FROM healthcare_data
GROUP BY Insurance_Provider;

------Admission Over Time:
Query: Count of admissions grouped by month.

SELECT FORMAT(Date_of_Admission, 'yyyy-MM') AS Admission_Month, COUNT(*) AS Total_Admissions
FROM healthcare_data
GROUP BY FORMAT(Date_of_Admission, 'yyyy-MM')
ORDER BY Admission_Month;

------Total Number of Admissions:
SELECT COUNT(*) AS Total_Number_of_Admissions
FROM healthcare_data;

------top 5 insurance provider by total patient
SELECT TOP 5
    Insurance_Provider, 
    COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY Insurance_Provider
ORDER BY Patient_Count DESC;


-----High or Low Billing Amount:

SELECT MAX(Billing_Amount) AS Highest_Billing_Amount, MIN(Billing_Amount) AS Lowest_Billing_Amount
FROM healthcare_data;

------Total Number of Patients:

SELECT COUNT(DISTINCT Name) AS Total_Number_of_Patients
FROM healthcare_data;

------Patient Distribution by Gender:
SELECT Gender, COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY Gender;

------Average Length of Stay (LOS):

SELECT AVG(DATEDIFF(day, Date_of_Admission, Discharge_Date)) AS Average_Length_of_Stay
FROM healthcare_data;

-------Patient Demographics Analysis:
--Query: Age distribution grouped by gender.
SELECT Gender, 
       AVG(Age) AS Average_Age,
       MIN(Age) AS Youngest_Age,
       MAX(Age) AS Oldest_Age,
       COUNT(*) AS Total_Patients
FROM healthcare_data
GROUP BY Gender;

---Billing Amounts by Medical Condition:
---Query: Average billing amount per medical condition.
SELECT Medical_Condition, AVG(Billing_Amount) AS Average_Billing_Amount
FROM healthcare_data
GROUP BY Medical_Condition;

----Top Revenue by Top Hospital:
-----Query: Identify the hospital generating the highest revenue from billing amounts.

SELECT TOP 10
    Hospital, 
    SUM(Billing_Amount) AS Total_Revenue
FROM healthcare_data
GROUP BY Hospital
ORDER BY Total_Revenue DESC;



--Total Admissions by Admission Type:
---Query: Count of admissions categorized by admission type (Urgent, Emergency, Elective).

SELECT Admission_Type, COUNT(*) AS Total_Admissions
FROM healthcare_data
GROUP BY Admission_Type;

--------Patient Age Distribution:
--------Query: Count of patients in different age ranges (e.g., 0-18, 19-35, 36-50, 51-65, 66+).
SELECT 
    CASE 
        WHEN Age < 19 THEN '0-18'
        WHEN Age BETWEEN 19 AND 35 THEN '19-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN Age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+'
    END AS Age_Range,
    COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY 
    CASE 
        WHEN Age < 19 THEN '0-18'
        WHEN Age BETWEEN 19 AND 35 THEN '19-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN Age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+'
    END;

---Readmission Rates:
---Query: Calculate readmission rates (assuming you have a way to identify readmissions).
SELECT 
    (COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM healthcare_data), 0)) AS Readmission_Percentage
FROM healthcare_data h1 
WHERE EXISTS (
    SELECT 1 
    FROM healthcare_data h2 
    WHERE h1.Name = h2.Name 
      AND h1.Discharge_Date IS NOT NULL
      AND h2.Date_of_Admission IS NOT NULL
      AND DATEDIFF(day, h1.Discharge_Date, h2.Date_of_Admission) <= 30
);

---------Total Billing Amount by Admission Type:
---------Query: Calculate total billing amounts categorized by admission type (Urgent, Emergency, Elective).

SELECT Admission_Type, SUM(Billing_Amount) AS Total_Billing_Amount
FROM healthcare_data
GROUP BY Admission_Type;

-------Average Billing Amount by Medical Condition:
-------Query: Calculate the average billing amount for each medical condition.

SELECT Medical_Condition, AVG(Billing_Amount) AS Average_Billing_Amount
FROM healthcare_data
GROUP BY Medical_Condition;

-----------Top 5 Medical Conditions with Highest Average Billing:

SELECT TOP 5 
    Medical_Condition, 
    AVG(Billing_Amount) AS Average_Billing
FROM healthcare_data
GROUP BY Medical_Condition
ORDER BY AVG(Billing_Amount) DESC;

-----Count of Patients by Blood Type:
----Query: Count the number of patients for each blood type.

SELECT Blood_Type, COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY Blood_Type;

-----Percentage of Patients with Each Medical Condition:
-----Query: Calculate the percentage of total patients diagnosed with each medical condition.

SELECT Medical_Condition,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM healthcare_data) AS Percentage_of_Patients
FROM healthcare_data
GROUP BY Medical_Condition;

----Total Number of Urgent Admissions vs. Elective Admissions:

SELECT Admission_Type, COUNT(*) AS Total_Count
FROM healthcare_data
WHERE Admission_Type IN ('Urgent', 'Elective')
GROUP BY Admission_Type;

---Correlation Between Age, Medical Condition, and Billing Amount:
---Query: Calculate the correlation between age, medical condition (using a numeric representation), and billing amount.

SELECT 
    AVG(Age) AS Average_Age,
    AVG(CASE WHEN Medical_Condition = 'Cancer' THEN 1 ELSE 0 END) AS Cancer_Indicator,
    AVG(Billing_Amount) AS Average_Billing
FROM healthcare_data;


-----Query: Count of admissions grouped by season.
SELECT 
    CASE 
        WHEN MONTH(Date_of_Admission) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(Date_of_Admission) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(Date_of_Admission) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
    END AS Season,
    COUNT(*) AS Total_Admissions
FROM healthcare_data
GROUP BY 
    CASE 
        WHEN MONTH(Date_of_Admission) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(Date_of_Admission) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(Date_of_Admission) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
    END;

------Patient Demographics Breakdown by Gender and Age Group:
------Analyze patient demographics based on gender and age groups.
SELECT 
    Gender,
    CASE 
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 35 THEN '18-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN Age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+'
    END AS Age_Group,
    COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY 
    Gender,
    CASE 
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 35 THEN '18-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN Age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+'
    END;

-----patient outcomes----
SELECT Test_Results, COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY Test_Results;

-----doctor workload-------
SELECT Doctor, COUNT(*) AS Patient_Count
FROM healthcare_data
GROUP BY Doctor
ORDER BY Patient_Count DESC;


