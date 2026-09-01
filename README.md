# IBM Employee Attrition Analysis 📊

## Project Overview

This project analyzes employee attrition and retention patterns using an end-to-end data analytics workflow.

**Workflow:** Excel → Power Query → Power BI → MySQL

**Objective:** Identify major attrition drivers, high-risk employee segments, and actionable HR retention opportunities.

**Dataset:** 1,470 employee records from the IBM HR Analytics Employee Attrition & Performance dataset.

---

## Tools Used

- Excel
- Power Query
- Power BI
- MySQL
- SQL

---

## Project Workflow

### Data Preparation

Performed:

- Data cleaning and standardization
- Data type transformation
- Duplicate and data quality checks
- Feature engineering
- Employee, tenure, income, satisfaction and risk classification

**Final Dataset:** 1,470 rows × 43 columns

### Data Modeling & Dashboard

Power BI was used for data modeling, DAX measures and dashboard development.

Analysis includes:

- Workforce and attrition
- Department and job role
- Demographics and age
- Experience and tenure
- Compensation
- Satisfaction and overtime
- Business travel
- Attrition risk

Interactive slicers enable analysis by department, job role, tenure, age group, gender and education field.

---

## Key KPIs

| KPI | Value |
|---|---:|
| Total Employees | **1,470** |
| Employees Left | **237** |
| Active Employees | **1,233** |
| Attrition Rate | **16.1%** |
| Active Employee Rate | **83.9%** |
| Average Age | **36.9 Years** |
| Average Tenure | **7.0 Years** |
| Average Monthly Salary | **$6.5K** |
| Average Satisfaction | **2.73 / 4** |

---

## Key Insights

- **Sales** has the highest department attrition at **20.6%**.
- **Sales Representative** has the highest role attrition at **39.8%**.
- Employees aged **18–25** show **35.8%** attrition.
- **Fresher employees (0–2 years)** show **43.9%** attrition.
- **New Joiners** show **36.4%** attrition.
- Employees working **overtime** show **30.5%** attrition versus **10.4%** without overtime.
- Employees who **travel frequently** show **24.9%** attrition.
- **High Risk** employees show **37.2%** attrition.

---

## SQL Validation

MySQL was used to independently validate Power BI and dataset metrics.

Performed:

- Data quality and structure checks
- Duplicate and missing-value validation
- KPI reconciliation
- Department and role analysis
- Demographic, tenure and experience analysis
- Compensation and satisfaction analysis
- Attrition-risk analysis

**SQL concepts:** Aggregations, `CASE`, `GROUP BY`, CTEs, window functions(`ROW_NUMBER()`), conditional aggregation and indexing.

## Project Structure

```
IBM-Employee-Attrition-Analysis/

├── 01_Raw_Data
│   └── Original dataset

├── 02_Cleaned_Data
│   └── Cleaned dataset after Power Query transformations

├── 03_SQL
│   └── MySQL validation and analytical queries

├── 04_Power_BI
│   └── Power BI dashboard (.pbix) file

├── 05_Screenshots
│   └── Dashboard and Power Query evidence screenshots

├── 06_Project_Report
│   └── Detailed project documentation

└── README.md
```
## Skills Demonstrated

- Data Cleaning
- Excel
- Power Query
- Feature Engineering
- Data Modeling
- DAX
- Power BI
- Dashboard Development
- SQL / MySQL
- KPI Validation
- Data Quality Checks
- Business Intelligence
- HR Analytics

## Conclusion

This project demonstrates an end-to-end data analytics workflow using Excel, Power Query, Power BI and MySQL to transform employee data into actionable attrition and retention insights.

## Project Information

**Project Title:** IBM Employee Attrition Analysis  
**Prepared By:** Ashish Verma  
**Role:** Data Analyst | MIS Analyst | Reporting Analyst  
**Tools Used:** Excel | Power Query | Power BI | MySQL  
**Project Type:** End-to-End Data Analytics & Business Intelligence Project
