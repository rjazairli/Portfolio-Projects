/* Data Cleaning */

-- 2018 Q3 Dataset
SELECT *
FROM dv01Loans.dbo.LoanStats_securev1_2018Q3$
ORDER BY id;

DELETE FROM dv01Loans.dbo.LoanStats_securev1_2018Q3$
WHERE id is NULL;

-- 2018 Q4 Dataset
SELECT *
FROM dv01Loans.dbo.LoanStats_securev1_2018Q4$
ORDER BY id;

DELETE FROM dv01Loans.dbo.LoanStats_securev1_2018Q4$
WHERE id is NULL;

-- 2019 Q1 Dataset
SELECT *
FROM dv01Loans.dbo.LoanStats_securev1_2019Q1$
ORDER BY id;

DELETE FROM dv01Loans.dbo.LoanStats_securev1_2019Q1$
WHERE id is NULL;

-- Back to 2018 Q3 Loan Data EDA
SELECT *
FROM dv01Loans.dbo.LoanStats_securev1_2018Q3$
ORDER BY id;

-- Number of loans issued by each state
SELECT addr_state, COUNT(*) as Total_Loans_By_State
FROM dv01Loans.dbo.LoanStats_securev1_2018Q3$
GROUP BY addr_state
ORDER BY 2 DESC;

-- Average loan amount by state
SELECT addr_state, ROUND(AVG(loan_amnt), 2) as Avg_Loan_Amnt_By_State
FROM dv01Loans.dbo.LoanStats_securev1_2018Q3$
GROUP BY addr_state
ORDER BY 2 DESC;

-- Total Number of Loans by Grade, Total Issued Loans by Grade, and Average Interest Rate by Loan Grade
SELECT grade, COUNT(*) as Grade_Total, SUM(loan_amnt) as Total_Issued, ROUND(AVG(int_rate), 4) as Avg_Int_Rate_By_Grade
FROM dv01Loans.dbo.LoanStats_securev1_2018Q3$
GROUP BY grade
ORDER BY 1;



-- 2018 Q3 Data Challenge:

WITH loan_data AS (
  SELECT 
    CASE WHEN grade IN ('F', 'G') THEN 'FG' ELSE grade END AS Grade_Group,
    SUM(loan_amnt) AS Total_Issued,
    SUM(CASE WHEN loan_status = 'Fully Paid' THEN loan_amnt ELSE 0 END) AS Total_Fully_Paid,
    ROUND(SUM(CASE WHEN loan_status IN ('Current', 'In Grace Period') THEN loan_amnt - total_rec_prncp ELSE 0 END), 0) AS Total_Current,
    ROUND(SUM(CASE WHEN loan_status IN ('Late (31-120 days)', 'Late (16-30 days)') THEN loan_amnt - total_rec_prncp ELSE 0 END), 0) AS Total_Late,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amnt - total_rec_prncp - recoveries ELSE 0 END), 0) AS Total_Charged_Off,
    ROUND(SUM(total_rec_prncp), 0) AS Total_Principal_Payments_Received,
    ROUND(SUM(total_rec_int), 0) AS Total_Interest_Payments_Received,
    ROUND(AVG(int_rate * 100), 2) AS Average_Interest_Rate,
    ROUND(AVG(annual_inc), 0) AS Average_Annual_Income,
    ROUND(AVG((fico_range_low + fico_range_high) / 2), 0) AS Average_Fico_Score
  FROM dv01Loans.dbo.LoanStats_securev1_2018Q3$
  GROUP BY CASE WHEN grade IN ('F', 'G') THEN 'FG' ELSE grade END
)
SELECT
  Grade_Group,
  Total_Issued,
  Total_Fully_Paid,
  Total_Current,
  Total_Late,
  Total_Charged_Off,
  Total_Principal_Payments_Received,
  Total_Interest_Payments_Received,
  Average_Interest_Rate,
  Average_Annual_Income,
  Average_Fico_Score
FROM loan_data
UNION ALL
SELECT
  'Grand_Total' AS Grade_Group,
  SUM(Total_Issued) AS Total_Issued,
  SUM(Total_Fully_Paid) AS Total_Fully_Paid,
  SUM(Total_Current) AS Total_Current,
  SUM(Total_Late) AS Total_Late,
  SUM(Total_Charged_Off) AS Total_Charged_Off,
  SUM(Total_Principal_Payments_Received) AS Total_Principal_Payments_Received,
  SUM(Total_Interest_Payments_Received) AS Total_Interest_Payments_Received,
  ROUND(AVG(Average_Interest_Rate), 2) AS Average_Interest_Rate,
  ROUND(AVG(Average_Annual_Income), 0) AS Average_Annual_Income,
  ROUND(AVG(Average_Fico_Score), 0) AS Average_Fico_Score
FROM loan_data
ORDER BY Grade_Group;



-- 2018 Q4 Data Challenge:

WITH loan_data AS (
  SELECT 
    CASE WHEN grade IN ('F', 'G') THEN 'FG' ELSE grade END AS Grade_Group,
    SUM(loan_amnt) AS Total_Issued,
    SUM(CASE WHEN loan_status = 'Fully Paid' THEN loan_amnt ELSE 0 END) AS Total_Fully_Paid,
    ROUND(SUM(CASE WHEN loan_status IN ('Current', 'In Grace Period') THEN loan_amnt - total_rec_prncp ELSE 0 END), 0) AS Total_Current,
    ROUND(SUM(CASE WHEN loan_status IN ('Late (31-120 days)', 'Late (16-30 days)') THEN loan_amnt - total_rec_prncp ELSE 0 END), 0) AS Total_Late,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amnt - total_rec_prncp - recoveries ELSE 0 END), 0) AS Total_Charged_Off,
    ROUND(SUM(total_rec_prncp), 0) AS Total_Principal_Payments_Received,
    ROUND(SUM(total_rec_int), 0) AS Total_Interest_Payments_Received,
    ROUND(AVG(int_rate * 100), 2) AS Average_Interest_Rate,
    ROUND(AVG(annual_inc), 0) AS Average_Annual_Income,
    ROUND(AVG((fico_range_low + fico_range_high) / 2), 0) AS Average_Fico_Score
  FROM dv01Loans.dbo.LoanStats_securev1_2018Q4$
  GROUP BY CASE WHEN grade IN ('F', 'G') THEN 'FG' ELSE grade END
)
SELECT
  Grade_Group,
  Total_Issued,
  Total_Fully_Paid,
  Total_Current,
  Total_Late,
  Total_Charged_Off,
  Total_Principal_Payments_Received,
  Total_Interest_Payments_Received,
  Average_Interest_Rate,
  Average_Annual_Income,
  Average_Fico_Score
FROM loan_data
UNION ALL
SELECT
  'Grand_Total' AS Grade_Group,
  SUM(Total_Issued) AS Total_Issued,
  SUM(Total_Fully_Paid) AS Total_Fully_Paid,
  SUM(Total_Current) AS Total_Current,
  SUM(Total_Late) AS Total_Late,
  SUM(Total_Charged_Off) AS Total_Charged_Off,
  SUM(Total_Principal_Payments_Received) AS Total_Principal_Payments_Received,
  SUM(Total_Interest_Payments_Received) AS Total_Interest_Payments_Received,
  ROUND(AVG(Average_Interest_Rate), 2) AS Average_Interest_Rate,
  ROUND(AVG(Average_Annual_Income), 0) AS Average_Annual_Income,
  ROUND(AVG(Average_Fico_Score), 0) AS Average_Fico_Score
FROM loan_data
ORDER BY Grade_Group;


-- 2019 Q1 Data Challenge:

WITH loan_data AS (
  SELECT 
    CASE WHEN grade IN ('F', 'G') THEN 'FG' ELSE grade END AS Grade_Group,
    SUM(loan_amnt) AS Total_Issued,
    SUM(CASE WHEN loan_status = 'Fully Paid' THEN loan_amnt ELSE 0 END) AS Total_Fully_Paid,
    ROUND(SUM(CASE WHEN loan_status IN ('Current', 'In Grace Period') THEN loan_amnt - total_rec_prncp ELSE 0 END), 0) AS Total_Current,
    ROUND(SUM(CASE WHEN loan_status IN ('Late (31-120 days)', 'Late (16-30 days)') THEN loan_amnt - total_rec_prncp ELSE 0 END), 0) AS Total_Late,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amnt - total_rec_prncp - recoveries ELSE 0 END), 0) AS Total_Charged_Off,
    ROUND(SUM(total_rec_prncp), 0) AS Total_Principal_Payments_Received,
    ROUND(SUM(total_rec_int), 0) AS Total_Interest_Payments_Received,
    ROUND(AVG(int_rate * 100), 2) AS Average_Interest_Rate,
    ROUND(AVG(annual_inc), 0) AS Average_Annual_Income,
    ROUND(AVG((fico_range_low + fico_range_high) / 2), 0) AS Average_Fico_Score
  FROM dv01Loans.dbo.LoanStats_securev1_2019Q1$
  GROUP BY CASE WHEN grade IN ('F', 'G') THEN 'FG' ELSE grade END
)
SELECT
  Grade_Group,
  Total_Issued,
  Total_Fully_Paid,
  Total_Current,
  Total_Late,
  Total_Charged_Off,
  Total_Principal_Payments_Received,
  Total_Interest_Payments_Received,
  Average_Interest_Rate,
  Average_Annual_Income,
  Average_Fico_Score
FROM loan_data
UNION ALL
SELECT
  'Grand_Total' AS Grade_Group,
  SUM(Total_Issued) AS Total_Issued,
  SUM(Total_Fully_Paid) AS Total_Fully_Paid,
  SUM(Total_Current) AS Total_Current,
  SUM(Total_Late) AS Total_Late,
  SUM(Total_Charged_Off) AS Total_Charged_Off,
  SUM(Total_Principal_Payments_Received) AS Total_Principal_Payments_Received,
  SUM(Total_Interest_Payments_Received) AS Total_Interest_Payments_Received,
  ROUND(AVG(Average_Interest_Rate), 2) AS Average_Interest_Rate,
  ROUND(AVG(Average_Annual_Income), 0) AS Average_Annual_Income,
  ROUND(AVG(Average_Fico_Score), 0) AS Average_Fico_Score
FROM loan_data
ORDER BY Grade_Group;