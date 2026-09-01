-- ============================================================
-- IBM HR ATTRITION ANALYSIS | FINAL 10/10 SQL PROJECT
-- ============================================================
-- Database: MySQL 8.0+
-- Primary table: employee_attrition
--
-- BUSINESS OBJECTIVE
-- ------------------------------------------------------------
-- Measure workforce size, attrition, employee retention, role and
-- department risk, demographics, tenure, compensation, satisfaction,
-- overtime, travel, and other workforce characteristics to support
-- evidence-based HR decisions.

-- ============================================================
-- IBM HR ATTRITION ANALYSIS
-- Purpose: HR KPI analysis, attrition drivers, business insights,
--          and data-quality validation

-- Note:
--   Single-table analysis. No JOINs are required.

-- ============================================================
-- 01. DATABASE & TABLE SETUP
-- QUERY PURPOSE: Create the HR analytics database and employee-level schema.
-- ============================================================
CREATE DATABASE hr_analytics;
USE hr_analytics;
CREATE TABLE employee_attrition (
Employee_ID INT PRIMARY KEY,
Employee_Status VARCHAR(20),
Attrition_Flag INT,
Attrition VARCHAR(10),
Age INT,
Age_Group VARCHAR(20),
Gender VARCHAR(15),
Marital_Status VARCHAR(30),
Education INT,
Education_Field VARCHAR(20),
Department VARCHAR(50),
Job_Role VARCHAR(50),
Job_Level INT,
Job_Involvement INT,
Business_Travel VARCHAR(30),
Distance_From_Home INT,
Distance_Category VARCHAR(30),
Daily_Rate INT,
Hourly_Rate INT,
Monthly_Rate INT,
Monthly_Income INT,
Income_Range VARCHAR(30),
Income_Category VARCHAR(30),
Percent_Salary_Hike INT,
Stock_Option_Level INT,
Performance_Rating INT,
Performance_Category VARCHAR(30),
Environment_Satisfaction INT,
Job_Satisfaction INT,
Relationship_Satisfaction INT,
Work_Life_Balance INT,
Overall_Satisfaction DECIMAL(3,2),
Over_Time VARCHAR(30),
Attrition_Risk VARCHAR(30),
Total_Working_Years INT,
Experience_Group VARCHAR(30),
Years_At_Company INT,
Company_Tenure VARCHAR(30),
Years_In_Current_Role INT,
Years_Since_Last_Promotion INT,
Years_With_Current_Manager INT,
Num_Companies_Worked INT,
Training_Times_Last_Year INT
);
-- ============================================================
-- 02. DATA IMPORT & MYSQL CONFIGURATION
-- QUERY PURPOSE: Configure MySQL and import the cleaned HR attrition dataset.
-- ============================================================
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_attrition_cleaned.csv.csv'
INTO TABLE employee_attrition
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ============================================================
-- 03. DATA QUALITY & STRUCTURE VALIDATION
-- QUERY PURPOSE: Validate employee identifiers, critical fields, and attrition consistency.
-- ============================================================
SHOW CREATE TABLE employee_attrition;
SELECT *
FROM employee_attrition
LIMIT 10;

-- 03.03 Validate total rows
SELECT COUNT(*) AS Total_Rows
FROM employee_attrition;

-- 03.04 Check duplicate Employee IDs
SELECT Employee_ID,
    COUNT(*) AS Duplicate_Count
FROM employee_attrition
GROUP BY Employee_ID
HAVING COUNT(*) > 1;

-- 03.05 Check missing critical fields
SELECT
    SUM(Employee_ID IS NULL) AS Missing_Employee_ID,
    SUM(Attrition IS NULL) AS Missing_Attrition
FROM employee_attrition;

-- 03.06 Validate Attrition_Flag against Attrition
SELECT
    COUNT(*) AS Inconsistent_Attrition_Flag_Records
FROM employee_attrition
WHERE (Attrition = 'Yes' AND Attrition_Flag <> 1)
   OR (Attrition = 'No' AND Attrition_Flag <> 0);


-- ============================================================
 -- 04. — QUERY PERFORMANCE OPTIMIZATION
-- QUERY PURPOSE: Add indexes that support common HR filtering and grouping operations.
 --  ============================================================ 
CREATE INDEX idx_attrition
ON employee_attrition(attrition);
CREATE INDEX idx_department
ON employee_attrition(Department);
CREATE INDEX idx_job_role
ON employee_attrition(Job_Role);

-- ============================================================
-- 05. OVERALL HR KPI ANALYSIS
-- QUERY PURPOSE: Establish executive workforce and attrition KPIs.
-- ============================================================
-- 05.01 Workforce size, attrition and core HR KPIs
SELECT 
	COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Active_Employees,  
	ROUND(AVG(Age),1)AS Average_Age,
    ROUND(AVG(Years_At_Company),1)AS Average_Company_Tenure,
    ROUND(AVG(Monthly_Income),1)AS Average_Monthly_Income,
    ROUND(AVG(Overall_Satisfaction),2)AS Average_Overall_Satisfaction,
    ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100/
          COUNT(*),2) AS Emp_Left_Rate,
	ROUND(SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END)*100/
          COUNT(*),2) AS Emp_Active_Rate
FROM employee_attrition;

-- 05.02 Attrition distribution
SELECT Attrition,
COUNT(*) AS Employees,ROUND(COUNT(*) * 100.0 / 
       SUM(COUNT(*)) OVER (),2) AS Employee_Percent
FROM employee_attrition
GROUP BY Attrition;

-- ============================================================
-- 06. DEPARTMENT & JOB ROLE ANALYSIS
-- QUERY PURPOSE: Identify attrition concentration and compensation differences by organizational role.
-- ============================================================
-- 06.01 Department attrition and compensation performance
SELECT department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100/
          COUNT(*),2) AS Attrition_Rate,
    SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Active_Employees,  
	ROUND(SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END)*100/
          COUNT(*),2) AS Emp_Active_Rate,
	ROUND(AVG(Monthly_Income),1)AS Average_Monthly_Income
FROM employee_attrition
GROUP BY department
ORDER BY Attrition_Rate DESC;

-- 06.02 Job role attrition and compensation performance
SELECT 
    job_role,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100/
          COUNT(*),2) AS Attrition_Rate,
    SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Active_Employees,  
	ROUND(SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END)*100/
          COUNT(*),2) AS Emp_Active_Rate ,         
          ROUND(AVG(Monthly_Income),0) AS Avg_Salary,
       SUM(Monthly_Income) AS Total_Monthly_Income
FROM employee_attrition
GROUP BY job_role
ORDER BY Attrition_Rate DESC;

-- 06.03 Top 3 highest  Attrition job roles within each department
WITH 
Job_Role_Rank AS
     (SELECT Department, Job_Role, 
			SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
            ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100/
								COUNT(*),2) AS Attrition_Rate
      FROM employee_attrition
      GROUP BY Department,Job_Role),
Ranked_Job_Role AS
      (SELECT Department ,Job_Role ,Employees_Left,Attrition_Rate,
              ROW_NUMBER() OVER(PARTITION BY Department
              ORDER BY Employees_Left DESC) AS Job_Rank 
       FROM Job_Role_Rank)
SELECT Department,  Job_Role,Employees_Left,Attrition_Rate,Job_Rank
FROM Ranked_Job_Role
WHERE Job_Rank <=3 ;

-- ============================================================
-- 07. DEMOGRAPHIC & AGE ANALYSIS
-- QUERY PURPOSE: Compare attrition across demographic and age segments.
-- ============================================================
-- 07.01 Attrition by age group
WITH
Emp_Details AS
	   (SELECT employee_id,age,attrition,
               CASE WHEN age >= 56 THEN '56+'
                  WHEN age >= 46 THEN '46-55'
                  WHEN age >= 35 THEN '35-45'
                  WHEN age >= 26 THEN '26-35'
                  ELSE '18-25' 
			  END AS Age_Group
	  FROM employee_attrition),
Emp_Group AS 
      (SELECT employee_id,Age_Group,
               SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
               ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100/
                         COUNT(*),2) AS Employees_Left_Rate,
               SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Active_Employees,  
			   ROUND(SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END)*100/
                          COUNT(*),2) AS Employees_Active_Rate
		FROM Emp_Details
        GROUP BY employee_id,Age_Group)
SELECT Age_Group,
	   COUNT(employee_Id) AS Total_Emp,
       SUM(Employees_Left) AS Total_Emp_Left,
               ROUND(AVG(Employees_Left_Rate),2) AS Emp_Left_Rate,
               SUM(Active_Employees) AS Total_Active_Emp,  
			   ROUND(AVG(Employees_Active_Rate),2) AS Emp_Active_Rate
FROM Emp_Group
GROUP BY Age_Group;

-- 07.02 Attrition by gender
SELECT Gender,
COUNT(*) AS Total_Employees,
SUM(Attrition = 'Yes') AS Employees_Left,
ROUND(SUM(Attrition = 'Yes')*100/COUNT(*),2) AS Attrition_Rate,
SUM(Attrition = 'No') AS Employees_Active,
ROUND(SUM(Attrition = 'No') * 100/COUNT(*),2) AS Active_Emp_Rate
FROM employee_attrition
GROUP BY Gender
ORDER BY Attrition_Rate DESC;

-- 07.03 Attrition by marital status
SELECT Marital_Status,
COUNT(*) AS Total_Employees,
SUM(Attrition = 'Yes') AS Employees_Left,
ROUND(SUM(Attrition = 'Yes')*100/COUNT(*),2) AS Attrition_Rate,
SUM(Attrition = 'No') AS Employees_Active,
ROUND(SUM(Attrition = 'No') * 100/COUNT(*),2) AS Active_Emp_Rate
FROM employee_attrition
GROUP BY Marital_Status
ORDER BY Attrition_Rate DESC;

-- ============================================================
-- 08. EXPERIENCE & TENURE ANALYSIS
-- QUERY PURPOSE: Evaluate attrition across career experience and company tenure.
-- ============================================================
-- 08.01 Attrition by total work experience
WITH
Emp_Details AS
	   (SELECT employee_id,Total_Working_Years,attrition,
               CASE WHEN Total_Working_Years <= 2 THEN 'Fresher(0-2)'
                  WHEN Total_Working_Years <= 5 THEN 'Junior(3-5)'
                  WHEN Total_Working_Years <= 10 THEN 'Mid-Level(6-10)'
                  WHEN Total_Working_Years <= 20 THEN 'Senior(11-20)'
                  ELSE 'Expert(20+)' 
			  END AS Work_Exp_Group
	  FROM employee_attrition),
Emp_Group AS 
      (SELECT employee_id,Work_Exp_Group,
               SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
               ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100/
                         COUNT(*),2) AS Employees_Left_Rate,
               SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Active_Employees,  
			   ROUND(SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END)*100/
                          COUNT(*),2) AS Employees_Active_Rate
		FROM Emp_Details
        GROUP BY employee_id,Work_Exp_Group)
SELECT Work_Exp_Group,
	   COUNT(employee_Id) AS Total_Emp,
       SUM(Employees_Left) AS Total_Emp_Left,
               ROUND(AVG(Employees_Left_Rate),2) AS Emp_Left_Rate,
               SUM(Active_Employees) AS Total_Active_Emp,  
			   ROUND(AVG(Employees_Active_Rate),2) AS Emp_Active_Rate
FROM Emp_Group
GROUP BY Work_Exp_Group;

-- 08.02 Attrition by company tenure
SELECT
    CASE
        WHEN Years_At_Company <= 2 THEN '0-2 Years'
        WHEN Years_At_Company <= 5 THEN '3-5 Years'
        WHEN Years_At_Company <= 10 THEN '6-10 Years'
        ELSE '11+ Years'
    END AS Company_Tenure_Group,
    COUNT(*) AS Total_Employees,
    SUM(Attrition = 'Yes') AS Employees_Left,
    ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*),2) AS Attrition_Rate
FROM employee_attrition
GROUP BY Company_Tenure_Group
ORDER BY MIN(Years_At_Company);

-- ============================================================
-- 09. COMPENSATION & PERFORMANCE ANALYSIS
-- QUERY PURPOSE: Assess attrition patterns across income categories.
-- ============================================================
-- 09.01 Attrition by income category
SELECT Income_Category,
    COUNT(*) AS Total_Employees,
    SUM(Attrition = 'Yes') AS Employees_Left,
    ROUND(SUM(Attrition = 'Yes') * 100/ COUNT(*),2) AS Attrition_Rate,
    ROUND(AVG(Monthly_Income), 0) AS Avg_Monthly_Income
FROM employee_attrition
GROUP BY Income_Category
ORDER BY Attrition_Rate DESC;

-- ============================================================
-- 10. EMPLOYEE SATISFACTION & WORK CONDITIONS
-- QUERY PURPOSE: Evaluate workplace conditions and satisfaction as attrition indicators.
-- ============================================================
-- 10.01 Attrition by overtime status
SELECT Over_Time,
    COUNT(*) AS Total_Employees,
    SUM(Attrition = 'Yes') AS Employees_Left,
    ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*),2) AS Attrition_Rate,
    ROUND(AVG(Overall_Satisfaction), 2) AS Avg_Overall_Satisfaction
FROM employee_attrition
GROUP BY Over_Time
ORDER BY Attrition_Rate DESC;

-- 10.02 Attrition by overall satisfaction
SELECT Overall_Satisfaction,
    COUNT(*) AS Total_Employees,
    SUM(Attrition = 'Yes') AS Employees_Left,
    ROUND(SUM(Attrition = 'Yes') * 100/ COUNT(*),2) AS Attrition_Rate
FROM employee_attrition
GROUP BY Overall_Satisfaction
ORDER BY Overall_Satisfaction;

-- 10.03 Attrition by business travel
SELECT Business_Travel,
    COUNT(*) AS Total_Employees,
    AVG(Distance_From_Home) AS Avg_Distance_From_Home,
    SUM(Attrition = 'Yes') AS Employees_Left,
    ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*),2) AS Attrition_Rate
FROM employee_attrition
GROUP BY Business_Travel
ORDER BY Attrition_Rate DESC;

-- 10.04 Attrition by work-life balance
SELECT Work_Life_Balance,
    COUNT(*) AS Total_Employees,
    SUM(Attrition = 'Yes') AS Employees_Left,
    ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*),2) AS Attrition_Rate
FROM employee_attrition
GROUP BY Work_Life_Balance
ORDER BY Work_Life_Balance;

-- ============================================================
-- 11. ATTRITION DRIVER & BUSINESS ANALYSIS
-- ============================================================
-- 11.01 Multi-factor attrition exposure analysis
WITH
Emp_Details AS
	 (SELECT * ,
	    CASE WHEN  Over_Time = "No" THEN "Low Risk"
			 WHEN  Over_Time = "Yes"
				   AND Overall_Satisfaction<=2
				   OR Years_Since_Last_Promotion>=5
				   OR Distance_From_Home>=16
			       THEN "High Risk"
			 ELSE "Moderate Risk"
	    END AS Risk_Category
	 FROM employee_attrition)
SELECT Risk_Category,
	   COUNT(employee_Id) AS Total_Emp,
	   SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
	   ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100/
                         COUNT(employee_Id),2) AS Employees_Left_Rate,
	   SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Active_Employees, 
	   ROUND(SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END)*100/
                         COUNT(Employee_ID),2) AS Employees_Active_Rate, 
       ROUND(AVG(Overall_Satisfaction),2) AS Avg_Overall_Satisfaction,
	   ROUND(AVG(Distance_From_Home),2) AS Avg_Distance_From_Home,
	   ROUND(AVG(Relationship_Satisfaction),2) AS Avg_Relationship_Satisfaction,
	   ROUND(AVG(Job_Satisfaction),2) AS Avg_Job_Satisfaction,
	   ROUND(AVG(Years_Since_Last_Promotion),2) AS Avg_Promotion_Year_Gap,
	   ROUND(AVG(Years_In_Current_Role),2) AS Avg_Years_In_Current_Role
FROM Emp_Details
GROUP BY Risk_Category;

-- ============================================================
-- END OF IBM HR ATTRITION ANALYSIS
-- ============================================================